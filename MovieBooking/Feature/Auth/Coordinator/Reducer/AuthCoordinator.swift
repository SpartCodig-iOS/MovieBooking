//
//  AuthCoordinator.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import ComposableArchitecture
import TCACoordinators
import SwiftUI

@Reducer
public struct AuthCoordinator {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var routes: [Route<AuthScreen.State>]

    public init() {
      @Shared(.inMemory("UserEntity")) var userEntity: UserEntity = .init()
      self.routes = [.root(.login(.init(userEntity: userEntity)), embedInNavigationView: true)]
    }
  }

  public enum Action:  BindableAction {
    case binding(BindingAction<State>)
    case router(IndexedRouterActionOf<AuthScreen>)
    case navigation(NavigationAction)
  }

  public enum NavigationAction: Equatable {
    case presentMain
    case removeView
  }


  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .router(let routeAction):
          return routerAction(state: &state, action: routeAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
    .forEachRoute(\.routes, action: \.router)
  }
}

extension AuthCoordinator {
  private func routerAction(
    state: inout State,
    action: IndexedRouterActionOf<AuthScreen>
  ) -> Effect<Action> {
    switch action {
      case .routeAction(id: _, action: .login(.navigation(.presentMain))):
        return .send(.navigation(.presentMain), animation: .easeIn)

      case .routeAction(id: _, action: .login(.navigation(.presentSignUp))):
        state.routes.push(.signUp(.init()))
        return .none

      case .routeAction(id: _, action: .signUp(.navigation(.backToLogin))):
        return .send(.navigation(.removeView), animation: .easeIn)

      case .routeAction(id: _, action: .signUp(.navigation(.presentMain))):
        return .send(.navigation(.presentMain), animation: .easeIn)

      default:
        return .none
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
      case .presentMain:
        return .none

      case .removeView:
        state.routes.goBackToRoot()
        return .none
    }
  }
}


extension AuthCoordinator {
  @Reducer(state: .equatable, .hashable)
  public enum AuthScreen {
    case login(LoginReducer)
    case signUp(SignUpReducer)
  }
}
