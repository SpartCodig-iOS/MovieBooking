//
//  AppReducer.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import ComposableArchitecture

@Reducer
struct AppReducer {

  @ObservableState
  enum State {
    case splash(Splash.State)
    case auth(AuthCoordinator.State)



    init() {
      self = .splash(.init())
    }
  }

  enum Action: ViewAction {
    case view(View)
    case scope(ScopeAction)
  }

  @CasePathable
  enum View {
    case presentAuth
    case presentMain
  }


  @CasePathable
  enum ScopeAction {
    case splash(Splash.Action)
    case auth(AuthCoordinator.Action)
  }

  @Dependency(\.continuousClock) var clock

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .view(let viewAction):
          return handleViewAction(&state, action: viewAction)

        case .scope(let scopeAction):
          return handleScopeAction(&state, action: scopeAction)
      }
    }
    .ifCaseLet(\.splash, action: \.scope.splash) {
      Splash()
    }
    .ifCaseLet(\.auth, action: \.scope.auth) {
      AuthCoordinator()
    }
  }
}

extension AppReducer {
  func handleViewAction(
    _ state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      // MARK: - 로그인 화면으로
    case .presentAuth:
      state = .auth(.init())
      return .none

    case .presentMain:
      return .none

    }
  }


  func handleScopeAction(
    _ state: inout State,
    action: ScopeAction
  ) -> Effect<Action> {
    switch action {
      case .splash(.navigation(.presentLogin)):
      return .run { send in
        try await clock.sleep(for: .seconds(2))
        await send(.view(.presentAuth))
      }

    case .splash(.navigation(.presentMain)):
      return .run { send in
        try await clock.sleep(for: .seconds(2))
        await send(.view(.presentMain))
      }


//    case .auth(.navigation(.presentMain)):
//      return .send(.view(.presentMain))
//
//    case .auth(.navigation(.presentMain)):
//      return .send(.view(.presentMain))


    default:
      return .none
    }
  }
}
