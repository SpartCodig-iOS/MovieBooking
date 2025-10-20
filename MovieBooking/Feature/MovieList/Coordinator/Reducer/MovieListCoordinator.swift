//
//  MovieListCoordinator.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/20/25.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer
public struct MovieListCoordinator {
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    var routes: [Route<MovieScreen.State>]
    
    public init() {
      self.routes = [.root(.list(.init()), embedInNavigationView: true)]
    }
  }
  
  public enum Action {
    case router(IndexedRouterActionOf<MovieScreen>)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .router(let routeAction):
        return routerAction(state: &state, action: routeAction)
      }
    }
    .forEachRoute(\.routes, action: \.router)
  }
}

extension MovieListCoordinator {
  private func routerAction(
    state: inout State,
    action: IndexedRouterActionOf<MovieScreen>
  ) -> Effect<Action> {
    switch action {
    case .routeAction(id: _, action: .list(.selectMovie(let id))):
      print("coordinator Tapped \(id)")
      state.routes.push(.detail(MovieDetailFeature.State(movieId: id)))
      return .none
    case .routeAction(id: _, action: .detail(.view(.onTapBookButton(let data)))):
      print("coordinator Tapped \(data)")
      state.routes.push(.book(.init(movieDetail: data)))
      return .none
    case .routeAction(id: _, action: .book(.alert(.presented(.confirmBookingSuccess)))):
      state.routes.goBackToRoot()
      return .none 
    default:
      return .none
    }
  }
}

@Reducer(state: .equatable, .hashable)
public enum MovieScreen {
  case list(MovieListFeature)
  case detail(MovieDetailFeature)
  case book(MovieBookFeature)
}

