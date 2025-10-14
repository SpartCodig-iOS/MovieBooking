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
      self.routes = [.root(.login(.init()), embedInNavigationView: true)]
    }
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case router(IndexedRouterActionOf<AuthScreen>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View {

  }



  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {

  }

  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {


  }


  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .router(let routeAction):
          return routerAction(state: &state, action: routeAction)

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

  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {

    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {

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

    }
  }
}


extension AuthCoordinator {
  @Reducer(state: .equatable, .hashable)
  public enum AuthScreen {
    case login(Login)
  }
}
