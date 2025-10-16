//
//  LoginReducer.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation

import AuthenticationServices

import ComposableArchitecture
import WeaveDI
import LogMacro


@Reducer
public struct LoginReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var socialType: SocialType? = nil
    var currentNonce: String? = nil
    var authError: String? = nil
    var showErrorPopUp: Bool = false
    @Shared(.appStorage("loginId"))
    var loginId : String = ""
    var loginPassword: String = ""

    @Shared var userEntity: UserEntity
    @Shared(.appStorage("isSaveUserId"))
    var saveUserId: Bool = false

    public init(
      userEntity: UserEntity
    ) {
      self._userEntity = Shared(wrappedValue: userEntity, .inMemory("UserEntity"))
      if saveUserId == true {
        self.$userEntity.withLock{
          $0.userId = loginId
        }
      } else {
        self.$loginId.withLock { $0 = "" }
      }
    }
  }
  
  @CasePathable
  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
    case showErrorPopUp(Bool)
    case loginId(String)
    case loginPassword(String)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View: Equatable {
    case closePopUp(Bool)
    case onAppear
  }



  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction {
    case prepareAppleRequest(ASAuthorizationAppleIDRequest)
    case appleCompletion(Result<ASAuthorization, Error>)
    case signInWithSocial(social: SocialType)
    case fetchLastLoginSession

  }
  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    case setUser(UserEntity)
    case setAuthError(String)
    case setNonce(String?)
    case setSocialType(SocialType?)
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {


  }


  nonisolated enum LoginCancelID: Hashable, Sendable {
    case session
    case apple
    case social
  }

  @Injected(AuthUseCaseImpl.self) var authUseCase
  @Dependency(\.continuousClock) var clock
  @Dependency(\.mainQueue) var mainQueue

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(\.showErrorPopUp):
          return .none

        case .binding(_):
          return .none

        case let .loginId(id):
          state.$loginId.withLock { $0 = id }
          return .none

        case let .loginPassword(password):
          state.loginPassword = password
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .async(let asyncAction):
          return handleAsyncAction(state: &state, action: asyncAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)

        case let .showErrorPopUp(popup):
          state.showErrorPopUp = popup
          return .none
      }
    }
  }
}

extension LoginReducer {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .closePopUp(let showErrorPopUp):
        state.showErrorPopUp = showErrorPopUp
        return .none

      case .onAppear:
        return .send(.async(.fetchLastLoginSession))
    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
      case .prepareAppleRequest(let request):
        let nonce = AppleLoginManger.shared.prepare(request)
        state.currentNonce = nonce
        return .none

      case .appleCompletion(let result):
        return .run { [nonce = state.currentNonce] send in
          do {
            guard
              case .success(let auth) = result,
              let credential = auth.credential as? ASAuthorizationAppleIDCredential,
              let nonce, !nonce.isEmpty
            else {
              await send(.inner(.setAuthError("Apple 자격정보/nonce 누락")))
              return
            }

            let user = try await authUseCase.signInWithAppleOnce(credential: credential, nonce: nonce)
            await send(.inner(.setUser(user)))

          } catch {
            await send(.inner(.setAuthError(error.localizedDescription)))
          }
        }
//        .debounce(id: LoginCancelID.apple, for: 0.1, scheduler: mainQueue)

      case .signInWithSocial(let social):
        return .run { send in
          let socialResult = await Result {
            try await authUseCase.signInWithSocial(type: social)
          }

          switch socialResult {
            case .success(let socialData):
              await send(.inner(.setUser(socialData)))

            case .failure(let error):
              await send(.inner(.setAuthError(error.localizedDescription)))
          }
      }
//        .debounce(id: LoginCancelID.social, for: 0.1, scheduler: mainQueue)

      case .fetchLastLoginSession:
        return .run {  send in
          let sessionResult = await Result {
            try await authUseCase.fetchCurrentSocialType()
          }

          switch sessionResult {
            case .success(let sessionData):
               await send(.inner(.setSocialType(sessionData)))

            case .failure(let error):
              #logDebug("세션 정보 가져오기 실패", error.localizedDescription)
          }
        }
//        .debounce(id: LoginCancelID.session, for: 0.1, scheduler: mainQueue)
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {

    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      case .setAuthError( _):
        state.authError = DomainError.authenticationFailed.errorDescription
        state.showErrorPopUp = true
        return .none

      case .setUser(let userEnity):
        state.$userEntity.withLock { $0 = userEnity}
        #logDebug("로그인 성공", state.userEntity)
        return .none

      case .setNonce(let nonce):
        state.currentNonce = nonce
        return .none

      case .setSocialType(let type):
              state.socialType = type
              return .none
    }
  }
}


extension LoginReducer.State: Hashable {
  public static func == (lhs: LoginReducer.State, rhs: LoginReducer.State) -> Bool {
    lhs.socialType == rhs.socialType &&
    lhs.currentNonce == rhs.currentNonce &&
    lhs.userEntity == rhs.userEntity &&
    lhs.authError == rhs.authError &&
    lhs.showErrorPopUp == rhs.showErrorPopUp  &&
    lhs.loginId == rhs.loginId &&
    lhs.loginPassword == rhs.loginPassword &&
    lhs.saveUserId == rhs.saveUserId
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(socialType)
    hasher.combine(currentNonce)
    hasher.combine(userEntity)
    hasher.combine(authError)
    hasher.combine(showErrorPopUp)
    hasher.combine(loginId)
    hasher.combine(loginPassword)
    hasher.combine(saveUserId)
  }
}
