//
//  MovieBookFeature.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/18/25.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct MovieBookFeature {
  @Dependency(\.fetchMovieTimesUseCase) var fetchMovieTimesUseCase
  @Dependency(\.fetchMovieTheatersUseCase) var fetchMovieTheatersUseCase
  @Dependency(\.createBookingUseCase) var createBookingUseCase

  @ObservableState
  struct State: Equatable, Sendable {
    let movieId: String
    let posterPath: String
    let title: String
    var theaters: [MovieTheater] = []
    var showTimes: [ShowTime] = []
    var selectedTheater: MovieTheater?
    var selectedShowTime: ShowTime?
    var numberOfPeople: Int = 1
    let pricePerTicket: Int = 13000
    var isBookingInProgress: Bool = false
    @Presents var alert: AlertState<Action.Alert>?
  }

  enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case async(AsyncAction)
    case inner(InnerAction)
    case alert(PresentationAction<Alert>)

    enum ViewAction {
      case onAppear
      case theaterSelected(MovieTheater)
      case showTimeSelected(ShowTime)
      case numberOfPeopleChanged(Int)
      case onTapBookButton
    }

    enum AsyncAction {
      case fetchTheatersResponse(Result<[MovieTheater], Error>)
      case fetchTimesResponse(Result<[ShowTime], Error>)
      case createBookingResponse(Result<BookingInfo, Error>)
    }

    enum InnerAction {
      case fetchTheaters
      case fetchTimes(theaterId: Int)
      case createBooking
    }

    enum Alert {
      case confirmBookingSuccess
    }
  }

  var body: some Reducer<State, Action>{
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.numberOfPeople):
        return .send(.view(.numberOfPeopleChanged(state.numberOfPeople)))
      case .binding(\.selectedShowTime):
        guard let selectedShowTime = state.selectedShowTime else { return .none }
        return .send(.view(.showTimeSelected(selectedShowTime)))
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
      case .alert:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
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
      state.selectedShowTime = nil
      state.showTimes = []
      return .send(.inner(.fetchTimes(theaterId: theater.id)))

    case .showTimeSelected(let showTime):
      state.selectedShowTime = showTime
      print(showTime.fullDisplay)
      return .none

    case .numberOfPeopleChanged(let count):
      state.numberOfPeople = max(1, count)
      return .none
      
    case .onTapBookButton:
      // 유효성 검사
      guard state.selectedTheater != nil,
            state.selectedShowTime != nil else {
        state.alert = AlertState(title: {
          TextState("예매 오류")
        }, actions: {
          ButtonState(role: .cancel) {
            TextState("확인")
          }
        }, message: {
          TextState("극장과 상영시간을 모두 선택해주세요.")
        })
        return .none
      }

      return .send(.inner(.createBooking))
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
      state.showTimes = times
      return .none

    case .fetchTimesResponse(.failure):
      return .none

    case .createBookingResponse(.success(let booking)):
      state.isBookingInProgress = false
      print("✅ 예매 성공!")
      print("예매 ID: \(booking.id)")
      print("영화: \(booking.movieTitle)")
      print("극장: \(booking.theaterName)")
      print("시간: \(booking.showTime)")
      print("인원: \(booking.numberOfPeople)명")
      print("총액: ₩\(booking.totalPrice.formatted())")

      state.alert = AlertState {
        TextState("예매 완료")
      } actions: {
        ButtonState(action: .confirmBookingSuccess) {
          TextState("확인")
        }
      } message: {
        TextState("영화 예매가 성공적으로 완료되었습니다!")
      }
      return .none

    case .createBookingResponse(.failure(let error)):
      state.isBookingInProgress = false
      state.alert = AlertState {
        TextState("예매 오류")
      } actions: {
        ButtonState(role: .cancel) {
          TextState("확인")
        }
      } message: {
        TextState("예매에 실패했습니다: \(error.localizedDescription)")
      }
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

    case .createBooking:
      guard let theater = state.selectedTheater,
            let showTime = state.selectedShowTime else {
        return .none
      }

      state.isBookingInProgress = true

      let bookingInfo = BookingInfo(
        movieId: state.movieId,
        movieTitle: state.title,
        posterPath: state.posterPath,
        theaterId: theater.id,
        theaterName: theater.name,
        showDate: showTime.date,
        showTime: showTime.time,
        numberOfPeople: state.numberOfPeople,
        totalPrice: state.pricePerTicket * state.numberOfPeople
      )

      return .run { send in
        await send(
          .async(
            .createBookingResponse(
              Result {
                try await createBookingUseCase.execute(bookingInfo)
              }
            )
          )
        )
      }
    }
  }
}
