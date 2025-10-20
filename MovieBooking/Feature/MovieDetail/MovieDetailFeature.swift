//
//  MovieDetailFeature.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MovieDetailFeature {
  @Dependency(\.fetchMovieDetailUseCase) var fetchMovieDetailUseCase
  public init() {}
  @ObservableState
  public struct State: Equatable {
    let movieId: Int
    var movieDetail: MovieDetail?
    var isLoading: Bool = false
    @Presents var alert: AlertState<Action.Alert>?
  }

  public enum Action: ViewAction {
    case view(ViewAction)
    case async(AsyncAction)
    case inner(InnerAction)
    case alert(PresentationAction<Alert>)

    public enum ViewAction {
      case onAppear
      case onTapBookButton(MovieDetail)
    }

    public enum AsyncAction {
      case fetchMovieDetail
    }

    public enum InnerAction {
      case fetchSuccess(MovieDetail)
      case fetchFailure(Error)
    }

    public enum Alert {
      case confirmDismiss
    }
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .view(let viewAction):
        return handleViewAction(state: &state, action: viewAction)

      case .async(let asyncAction):
        return handleAsyncAction(state: &state, action: asyncAction)

      case .inner(let innerAction):
        return handleInnerAction(state: &state, action: innerAction)

      case .alert(.presented(let alertAction)):
        return handleAlertAction(state: &state, action: alertAction)

      case .alert(.dismiss):
        return .none
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
    case .onTapBookButton:
      return .none
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

      let movieDetailError = error as? MovieDetailError ?? MovieDetailError(from: error)
      let title = movieDetailError.title
      let message = movieDetailError.errorDescription ?? "오류가 발생했습니다"

      state.alert = AlertState {
        TextState(title)
      } actions: {
        ButtonState(action: .confirmDismiss) {
          TextState("확인")
        }
      } message: {
        TextState(message)
      }

      return .none
    }
  }
  
  private func handleAlertAction(
      state: inout State,
      action: Action.Alert
    ) -> Effect<Action> {
      switch action {
      case .confirmDismiss:
        // TODO: 뒤로가기 액션 (DismissEffect 등)
        return .none
      }
    }
}

extension MovieDetailFeature.State: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(movieId)
    hasher.combine(movieDetail)
    hasher.combine(isLoading)
    // @Presents var alert는 Hashable이 아니므로 제외
  }
}
