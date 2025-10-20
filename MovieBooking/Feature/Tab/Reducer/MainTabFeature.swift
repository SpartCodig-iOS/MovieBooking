//
//  MainTabFeature.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MainTabFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    var selectTab: MainTab = .home

    var movieList = MovieListFeature.State()
    var movieSearch = MovieSearchFeature.State()
    var myPage = MyPageFeature.State()
    var ticket = BookingListFeature.State()

    public init() {}
  }

  public enum Action : BindableAction{
    case binding(BindingAction<State>)
    case selectTab(MainTab)
    case scope(ScopeAction)
    case navigation(NavigationAction)
  }

  public enum NavigationAction {
    case backToLogin
  }

  @CasePathable
  public enum ScopeAction {
    case movieList(MovieListFeature.Action)
    case movieSearch(MovieSearchFeature.Action)
    case myPage(MyPageFeature.Action)
    case ticket(BookingListFeature.Action)
  }


  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .selectTab(let tab):
          state.selectTab = tab
          return .none

        case .scope(let scopeAction):
          return handleScopeAction(state: &state, action: scopeAction)

        case .navigation(let  navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
    Scope(state: \.movieList, action: \.scope.movieList) {
      MovieListFeature()
    }
    Scope(state: \.movieSearch, action: \.scope.movieSearch) {
      MovieSearchFeature()
    }
    Scope(state: \.myPage, action: \.scope.myPage) {
      MyPageFeature()
    }
    Scope(state: \.ticket, action: \.scope.ticket) {
      BookingListFeature()
    }
  }
}

extension MainTabFeature {
  private func handleScopeAction(
    state: inout State,
    action: ScopeAction
  ) -> Effect<Action> {
    switch action {
      case let .movieList(.fetchNowPlayingResponse(.success(movies))):
        state.movieSearch.nowPlayingMovies = movies
        return .none

      case let .movieList(.fetchUpcomingResponse(.success(movies))):
        state.movieSearch.upcomingMovies = movies
        return .none

      case let .movieList(.fetchPopularResponse(.success(movies))):
        state.movieSearch.popularMovies = movies
        return .none

      case .myPage(.navigation(.logOutComplete)):
        return .send(.navigation(.backToLogin), animation: .easeIn)

      default:
        return .none
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
      case .backToLogin:
        return .none
    }
  }
}

extension MainTabFeature.State: Hashable {
  public static func == (lhs: MainTabFeature.State, rhs: MainTabFeature.State) -> Bool {
    lhs.selectTab == rhs.selectTab
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(selectTab)
  }
}
