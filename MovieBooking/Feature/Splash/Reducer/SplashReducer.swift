//
//  SplashFeature.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//


import Foundation
import ComposableArchitecture
import SwiftUI
import WeaveDI
import LogMacro
import Supabase


@Reducer
public struct SplashFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    
    var fadeOut: Bool = false
    var pulse: Bool = false
    @Shared(.inMemory("UserEntity")) var userEntity: UserEntity = .init()
    var superbase = SuperBaseManger.shared.client
    public init() {}
  }

  @CasePathable
  public enum Action: ViewAction, Equatable, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View : Equatable{
    case onAppear
    case startAnimation

  }


  //MARK: - AsyncAction 비동기 처리 액션
  @CasePathable
  public enum AsyncAction: Equatable {
    case checkSession
    case runAuthCheck
    case refreshSession
  }

  //MARK: - 앱내에서 사용하는 액션
  @CasePathable
  public enum InnerAction: Equatable {
    case setPulse(Bool)
    case setFadeOut(Bool)
    case setUser(UserEntity)
  }

  //MARK: - NavigationAction
  @CasePathable
  public enum NavigationAction: Equatable {
    case presentLogin
    case presentMain


  }

  @Dependency(\.continuousClock) var clock
  @Injected(AuthUseCase.self) var authUseCase

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

extension SplashFeature {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .onAppear:
        return .send(.view(.startAnimation))

      case .startAnimation:
        return .run { send in
          await send(.inner(.setPulse(true)))

          try await clock.sleep(for: .seconds(1.3))
          await send(.inner(.setFadeOut(true)))
          await send(.navigation(.presentLogin))
        }
    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {

      case .checkSession:
        return .run {  send in
          let checkSessionResult = await Result {
            try await authUseCase.checkSession()
          }

          switch checkSessionResult {
            case .success(let checkSessionData):
              await send(.inner(.setUser(checkSessionData)))

            case .failure(let error):
              #logDebug("세션 확인 불가", error.localizedDescription)
              await send(.navigation(.presentLogin))
          }
        }


      case .runAuthCheck:
        return .run {  [superbase = state.superbase] send in
          await send(.async(.checkSession))

          if let session = superbase.auth.currentSession {
            if await authUseCase.isTokenExpiringSoon(session, threshold: 60) {
              #logDebug("토근 만료 입박 ")
              await send(.async(.refreshSession))
            } else {
              #logDebug("토큰 아직 유효 ")
            }
          }

          if let user = try?  await authUseCase.checkSession() {
            let uuid = UUID(uuidString: user.id)!
            let exists = try? await authUseCase.checkUserExists(userId: uuid)
            #logDebug(exists == true ? "✅ 메인으로 이동" : "⚠️ 프로필 등록 필요")
            if exists ?? false  {
              await send(.navigation(.presentMain))
            } else {
              await send(.navigation(.presentLogin))
            }
          }
        }


      case .refreshSession:
        return .run { send in
          let sessionResult = await Result {
            try await authUseCase.refreshSession()
          }

          switch sessionResult {
            case .success(let userData):
              await send(.inner(.setUser(userData)))

            case .failure(let error):
              #logDebug("세션 확인 불가", error.localizedDescription)
              await send(.navigation(.presentLogin))
          }
        }
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
        // 로그인 안했을경우
      case .presentLogin:
        return .none

        // 로그인 했을경우
      case .presentMain:
        return .none
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      case .setPulse(let on):
        state.pulse = on
        return .none

      case .setFadeOut(let on):
        withAnimation(.easeInOut(duration: 3)) {
          state.fadeOut = on
        }
        return .none

      case .setUser(let userEnitty):
        state.$userEntity.withLock { $0 = userEnitty }
        return .none
    }
  }
}



extension SplashFeature.State: Hashable {
  public static func == (lhs: SplashFeature.State, rhs: SplashFeature.State) -> Bool {
    return lhs.fadeOut == rhs.fadeOut &&
    lhs.pulse == rhs.pulse &&
    lhs.userEntity == rhs.userEntity

  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(fadeOut)
    hasher.combine(pulse)
    hasher.combine(userEntity)
  }
}

