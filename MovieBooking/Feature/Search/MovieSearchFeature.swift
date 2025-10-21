//
//  MovieSearchFeature.swift
//  MovieBooking
//
//  Created by 김민희 on 10/16/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MovieSearchFeature {
  @Dependency(\.searchMovieUseCase) var searchMovieUseCase
  @Dependency(\.mainQueue) var mainQueue

  @ObservableState
  public struct State: Equatable {
    var movies: [Movie] = []
    var searchText: String = ""
  }

  public enum Action: BindableAction {
    case updateMovieLists([Movie])
    case binding(BindingAction<State>)
    case searchTextChanged
  }
  
  nonisolated enum CancelID: Hashable, Sendable { case search }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .updateMovieLists(movies):
        state.movies = movies
        return .none
      case .binding(\.searchText):
        return .send(.searchTextChanged)
          .debounce(id: CancelID.search, for: 0.5, scheduler: mainQueue)

      case .binding:
        return .none
      case .searchTextChanged:
        let query = state.searchText
        guard !query.isEmpty else {
          state.movies = []
          return .none
        }
        
        return .run { send in
          let movies = try await searchMovieUseCase.execute(query)
          await send(.updateMovieLists(movies))
        }
      }
    }
  }
}
