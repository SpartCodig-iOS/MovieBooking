//
//  AppReducer.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppReducer {

  @ObservableState
  enum State {
    case splash(SplashReducer.State)
    case auth(AuthCoordinator.State)
    case mainTab(MainTabReducer.State)



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
    case splash(SplashReducer.Action)
    case auth(AuthCoordinator.Action)
    case mainTab(MainTabReducer.Action)
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
      SplashReducer()
    }
    .ifCaseLet(\.auth, action: \.scope.auth) {
      AuthCoordinator()
    }
    .ifCaseLet(\.mainTab, action: \.scope.mainTab) {
      MainTabReducer()
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
        state = .mainTab(.init())
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
        try await clock.sleep(for: .seconds(1))
        await send(.view(.presentAuth))
      }

    case .splash(.navigation(.presentMain)):
      return .run { send in
        try await clock.sleep(for: .seconds(1))
        await send(.view(.presentMain))
      }


    case .auth(.navigation(.presentMain)):
      return .send(.view(.presentMain),  animation: .easeIn)

    default:
      return .none
    }
  }
}
