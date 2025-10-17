//
//  SignUpReducer.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//


import Foundation
import ComposableArchitecture
import WeaveDI
import SwiftUI

@Reducer
public struct SignUpReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    @Shared(.inMemory("UserEntity")) var userEntity: UserEntity = .init()

    var userPassword: String = ""
    var checkPassword: String = ""
    var userEmail: String = ""
    var userName: String = ""
    var focusedField: FocusedField? = .name
    enum FocusedField: Equatable { case name, password, checkPassword , email}

    var authError: String? = nil
    var authErrorMesage: String? = nil

    var userNameError: String? = nil
     var userEmailError: String? = nil
     var passwordError: String? = nil
     var checkPasswordError: String? = nil

    var showAlert: Bool = false
    var isSuccessSignUp: Bool = false

    var isEnable: Bool {
      !userEmail.isEmpty && !userName.isEmpty  && !userPassword.isEmpty && userPassword == checkPassword
    }

    public init() {
      
    }
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case appearAlert(Bool)
    case closeAlert
    case setSuccessSignUp(Bool)
  }


  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case signUpUser
  }

  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    case setUser(UserEntity)
    case setAuthError(String)
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case backToLogin
    case presentMain

  }

  nonisolated enum SignUpCancelID: Hashable, Sendable {
    case auth
  }

  @Injected(AuthUseCaseImpl.self) var authUseCase
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.continuousClock) var clock

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .async(let asyncAction):
          return handleAsyncAction(state: &state, action: asyncAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
  }
}

extension SignUpReducer {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .appearAlert(let bool):
        state.showAlert = bool
        state.authError = "회원가입에 성공했습니다."
        state.authErrorMesage = "메인 화면으로 이동합니다.\n(아이디는 이메일이랑 이메일 @앞부터 나오는 부분을 사용하시면 됩니다)"
        return .none

      case .closeAlert:
        state.showAlert = false
        return .none

      case .setSuccessSignUp(let bool):
        state.isSuccessSignUp = bool
        return .none
    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
      case .signUpUser:
        return .run { [
          email = state.userEmail,
          password = state.userPassword ,
          name = state.userName
        ]  send in

          let signUpResult = await Result {
            try await authUseCase.signUpNormalUser(name: name, email: email, password: password)
          }

          switch signUpResult {
            case .success(let userData):
              await send(.inner(.setUser(userData)))

              await send(.view(.setSuccessSignUp(true)))

              try await clock.sleep(for: .seconds(0.2))
              await send(.view(.appearAlert(true)))

            case .failure(let error):
              await send(.inner(.setAuthError("회원가입 에 실패했습니다. \(error.localizedDescription)")))
          }
        }
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
      case .backToLogin:
        return . none

      case .presentMain:
        return .none
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      case .setAuthError(let error):
        state.authErrorMesage = error.description
        state.authError = DomainError.loginFailed.errorDescription
        return .none

      case .setUser(let userEntity):
        state.$userEntity.withLock { $0 = userEntity }
        return .none
    }
  }
}

extension SignUpReducer.State: Hashable {
  public static func == (lhs: SignUpReducer.State, rhs: SignUpReducer.State) -> Bool {
    return lhs.userEmail == rhs.userEmail &&
    lhs.userPassword == rhs.userPassword &&
    lhs.checkPassword == rhs.checkPassword &&
    lhs.userName == rhs.userName &&
    lhs.authError == rhs.authError &&
    lhs.authErrorMesage == rhs.authErrorMesage &&
    lhs.userNameError == rhs.userNameError &&
    lhs.userEmailError == rhs.userEmailError &&
    lhs.passwordError == rhs.passwordError &&
    lhs.checkPasswordError == rhs.checkPasswordError &&
    lhs.showAlert == rhs.showAlert &&
    lhs.isSuccessSignUp == rhs.isSuccessSignUp
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(userEmail)
    hasher.combine(userPassword)
    hasher.combine(checkPassword)
    hasher.combine(userName)
    hasher.combine(authError)
    hasher.combine(authErrorMesage)
    hasher.combine(userNameError)
    hasher.combine(userEmailError)
    hasher.combine(passwordError)
    hasher.combine(checkPasswordError)
    hasher.combine(showAlert)
    hasher.combine(isSuccessSignUp)
  }
}
