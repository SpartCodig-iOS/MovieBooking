//
//  BookingListFeature.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BookingListFeature {
  @Dependency(\.fetchBookingsUseCase) var fetchBookingsUseCase

  @ObservableState
  struct State {
    var bookings: [BookingInfo] = []
    var isLoading: Bool = false
    var errorMessage: String?
  }

  enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case async(AsyncAction)
    case inner(InnerAction)

    enum ViewAction {
      case onAppear
      case refreshButtonTapped
      case deleteBooking(id: String)
    }

    enum AsyncAction {
      case fetchBookingsResponse(Result<[BookingInfo], Error>)
    }

    enum InnerAction {
      case fetchBookings
    }
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
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

extension BookingListFeature {
  func handleViewAction(
    _ state: inout State,
    _ action: Action.ViewAction
  ) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(.inner(.fetchBookings))

    case .refreshButtonTapped:
      return .send(.inner(.fetchBookings))

    case .deleteBooking(let id):
      // TODO: DeleteBookingUseCase 구현 후 처리
      state.bookings.removeAll { $0.id == id }
      return .none
    }
  }

  func handleAsyncAction(
    _ state: inout State,
    _ action: Action.AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchBookingsResponse(.success(let bookings)):
      state.isLoading = false
      state.bookings = bookings
      state.errorMessage = nil
      return .none

    case .fetchBookingsResponse(.failure(let error)):
      state.isLoading = false
      state.errorMessage = error.localizedDescription
      return .none
    }
  }

  func handleInnerAction(
    _ state: inout State,
    _ action: Action.InnerAction
  ) -> Effect<Action> {
    switch action {
    case .fetchBookings:
      state.isLoading = true
      return .run { send in
        await send(
          .async(
            .fetchBookingsResponse(
              Result {
                try await fetchBookingsUseCase.execute()
              }
            )
          )
        )
      }
    }
  }
}
