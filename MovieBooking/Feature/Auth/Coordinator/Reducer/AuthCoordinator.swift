//
//  AuthCoordinator.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

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
  }


  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .router(let routeAction):
          return routerAction(state: &state, action: routeAction)
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
      default:
        return .none
    }
  }
}


extension AuthCoordinator {
  @Reducer(state: .equatable, .hashable)
  public enum AuthScreen {
    case login(LoginReducer)
  }
}
