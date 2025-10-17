//
//  MainTabFeature.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import Foundation
import ComposableArchitecture


@Reducer
public struct MainTabFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    var selectTab: MainTab = .home


    var movieList = MovieListFeature.State()
    var movieSearch = MovieSearchFeature.State()
    
    public init() {}
  }

  public enum Action : BindableAction{
    case binding(BindingAction<State>)
    case selectTab(MainTab)
    case scope(ScopeAction)

  }

  @CasePathable
  public enum ScopeAction {
    case movieList(MovieListFeature.Action)
    case movieSearch(MovieSearchFeature.Action)
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
      }
    }
    Scope(state: \.movieList, action: \.scope.movieList) {
      MovieListFeature()
    }
    Scope(state: \.movieSearch, action: \.scope.movieSearch) {
      MovieSearchFeature()
    }
  }
}

extension MainTabFeature {
  private func handleScopeAction(
    state: inout State,
    action: ScopeAction
  ) -> Effect<Action> {
    switch action {
      default:
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
