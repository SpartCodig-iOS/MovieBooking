//
//  MovieBookFeature.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/18/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieBookFeature {
  @Dependency(\.fetchMovieTimesUseCase) var fetchMovieTimesUseCase
  @Dependency(\.fetchMovieTheatersUseCase) var fetchMovieTheatersUseCase

  @ObservableState
  struct State {
    let movieId: String
    let posterPath: String
    let title: String
    var theaters: [MovieTheater] = []
    var times: [String] = []
    var selectedTheater: MovieTheater?
    var selectedTime: String?
    var numberOfPeople: Int = 1
    let pricePerTicket: Int = 13000
  }

  enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case async(AsyncAction)
    case inner(InnerAction)

    enum ViewAction {
      case onAppear
      case theaterSelected(MovieTheater)
      case timeSelected(String)
      case numberOfPeopleChanged(Int)
      case onTapBookButton
    }

    enum AsyncAction {
      case fetchTheatersResponse(Result<[MovieTheater], Error>)
      case fetchTimesResponse(Result<[String], Error>)
    }

    enum InnerAction {
      case fetchTheaters
      case fetchTimes(theaterId: Int)
    }
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.numberOfPeople):
        return .send(.view(.numberOfPeopleChanged(state.numberOfPeople)))
      case .binding(\.selectedTime):
        guard let selectedTime = state.selectedTime else { return .none }
        return .send(.view(.timeSelected(selectedTime)))
      case .binding(\.selectedTheater):
        guard let selectedTheater = state.selectedTheater else { return .none }
        return .send(.view(.theaterSelected(selectedTheater)))
      case .binding:
        return .none
      case .view(let viewAction):
        return handleViewAction(&state, viewAction)
      case .async(let asyncAction):
        return handleAsyncAction(&state, asyncAction)
      case .inner(let innerAction):
        return handleInnerAction(&state, innerAction)
      }
    }
  }
}

extension MovieBookFeature {
  func handleViewAction(
    _ state: inout State,
    _ action: Action.ViewAction
  ) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(.inner(.fetchTheaters))

    case .theaterSelected(let theater):
      state.selectedTheater = theater
      state.selectedTime = nil
      state.times = []
      return .send(.inner(.fetchTimes(theaterId: theater.id)))

    case .timeSelected(let time):
      state.selectedTime = time
      print(time)
      return .none

    case .numberOfPeopleChanged(let count):
      state.numberOfPeople = max(1, count)
      return .none
      
    case .onTapBookButton:
      print("결제하기 버튼 눌림")
      print("극장: \(state.selectedTheater?.name ?? "선택 안 됨")")
      print("시간: \(state.selectedTime ?? "선택 안 됨")")
      print("인원: \(state.numberOfPeople)명")
      print("총액: ₩\((state.pricePerTicket * state.numberOfPeople).formatted())")
      return .none
    }
  }

  func handleAsyncAction(
    _ state: inout State,
    _ action: Action.AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchTheatersResponse(.success(let theaters)):
      state.theaters = theaters
      return .none

    case .fetchTheatersResponse(.failure):
      return .none

    case .fetchTimesResponse(.success(let times)):
      state.times = times
      return .none

    case .fetchTimesResponse(.failure):
      return .none
    }
  }

  func handleInnerAction(
    _ state: inout State,
    _ action: Action.InnerAction
  ) -> Effect<Action> {
    switch action {
    case .fetchTheaters:
      return .run { [movieId = state.movieId] send in
        await send(
          .async(
            .fetchTheatersResponse(
              Result {
                try await fetchMovieTheatersUseCase.execute(movieId)
              }
            )
          )
        )
      }

    case .fetchTimes(let theaterId):
      return .run { [movieId = state.movieId] send in
        await send(
          .async(
            .fetchTimesResponse(
              Result {
                try await fetchMovieTimesUseCase.execute(movieId, at: theaterId)
              }
            )
          )
        )
      }
    }
  }
}
