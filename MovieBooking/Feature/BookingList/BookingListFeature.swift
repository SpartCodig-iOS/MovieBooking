//
//  BookingListFeature.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct BookingListFeature {
  @Dependency(\.fetchBookingsUseCase) var fetchBookingsUseCase
  @Dependency(\.deleteBookingUseCase) var deleteBookingUseCase

  @ObservableState
  public struct State {
    var bookings: [BookingInfo] = []
    var isLoading: Bool = false
    var errorMessage: String?
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case async(AsyncAction)
    case inner(InnerAction)

    public enum ViewAction {
      case onAppear
      case refreshButtonTapped
      case deleteBooking(id: String)
    }

    public enum AsyncAction {
      case fetchBookingsResponse(Result<[BookingInfo], Error>)
      case deleteBookingResponse(id: String, Result<Void, Error>)
    }

    public enum InnerAction {
      case fetchBookings
      case deleteBooking(id: String)
    }
  }

  public var body: some Reducer<State, Action> {
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
      return .send(.inner(.deleteBooking(id: id)))
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

    case .deleteBookingResponse(let id, .success):
      // 로컬 상태에서 삭제
      state.bookings.removeAll { $0.id == id }
      return .none

    case .deleteBookingResponse(_, .failure(let error)):
      state.errorMessage = "삭제 실패: \(error.localizedDescription)"
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

    case .deleteBooking(let id):
      return .run { send in
        await send(
          .async(
            .deleteBookingResponse(
              id: id,
              Result {
                try await deleteBookingUseCase.execute(id: id)
              }
            )
          )
        )
      }
    }
  }
}
