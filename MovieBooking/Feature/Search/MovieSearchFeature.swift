//
//  MovieSearchFeature.swift
//  MovieBooking
//
//  Created by 김민희 on 10/16/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MovieSearchFeature {
  @ObservableState
  struct State: Equatable {
    var nowPlayingMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var searchText: String = ""
  }

  enum Action: BindableAction {
    case updateMovieLists(nowPlaying: [Movie], upcoming: [Movie], popular: [Movie])
    case binding(BindingAction<State>)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .updateMovieLists(nowPlaying, upcoming, popular):
        state.nowPlayingMovies = nowPlaying
        state.upcomingMovies = upcoming
        state.popularMovies = popular
        return .none

      case .binding:
        return .none
      }
    }
  }
}


extension MovieSearchFeature.State {
  var trimmedKeyword: String {
    searchText.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var aggregatedMovies: [Movie] {
    let combined = nowPlayingMovies + upcomingMovies + popularMovies
    var unique: [Movie] = []
    var seenIDs = Set<Int>()

    for movie in combined where seenIDs.insert(movie.id).inserted {
      unique.append(movie)
    }

    return unique
  }

  var filteredMovies: [Movie] {
    guard !trimmedKeyword.isEmpty else { return [] }

    return aggregatedMovies.filter {
      $0.title.localizedCaseInsensitiveContains(trimmedKeyword)
    }
  }
}
