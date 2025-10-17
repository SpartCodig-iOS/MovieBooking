//
//  MovieDetailFeature.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieDetailFeature {
  @Dependency(\.fetchMovieDetailUseCase) var fetchMovieDetailUseCase
  
  @ObservableState
  struct State {
    let movieId: Int
    var movieDetail: MovieDetail?
    var isLoading: Bool = false
  }

  enum Action: ViewAction {
    case view(ViewAction)
    case async(AsyncAction)
    case inner(InnerAction)

    enum ViewAction {
      case onAppear
    }

    enum AsyncAction {
      case fetchMovieDetail
    }

    enum InnerAction {
      case fetchSuccess(MovieDetail)
      case fetchFailure(Error)
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewAction):
        return handleViewAction(state: &state, action: viewAction)

      case .async(let asyncAction):
        return handleAsyncAction(state: &state, action: asyncAction)

      case .inner(let innerAction):
        return handleInnerAction(state: &state, action: innerAction)
      }
    }
  }
}

extension MovieDetailFeature {
  private func handleViewAction(
    state: inout State,
    action: Action.ViewAction
  ) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(.async(.fetchMovieDetail))
    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: Action.AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchMovieDetail:
      state.isLoading = true

      return .run { [movieId = state.movieId] send in
        do {
          let movieDetail = try await fetchMovieDetailUseCase.execute(String(movieId))
          await send(.inner(.fetchSuccess(movieDetail)))
        } catch {
          await send(.inner(.fetchFailure(error)))
        }
      }
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: Action.InnerAction
  ) -> Effect<Action> {
    switch action {
    case .fetchSuccess(let movieDetail):
      state.isLoading = false
      state.movieDetail = movieDetail
      return .none

    case .fetchFailure(let error):
      state.isLoading = false
      return .none
    }
  }
}
