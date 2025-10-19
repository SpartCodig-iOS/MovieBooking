//
//  FetchBookingsUseCase.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation
import Dependencies

protocol FetchBookingsUseCaseProtocol {
  func execute() async throws -> [BookingInfo]
}

struct FetchBookingsUseCase: FetchBookingsUseCaseProtocol {
  @Dependency(\.bookingRepository) var repository

  func execute() async throws -> [BookingInfo] {
    try await Task.sleep(nanoseconds: 300_000_000) // 0.3초
    let bookings = try await repository.fetchBookings()

    // 예매 날짜 최신순으로 정렬
    return bookings.sorted { $0.bookedAt > $1.bookedAt }
  }
}

private enum FetchBookingsUseCaseKey: DependencyKey {
  static let liveValue: FetchBookingsUseCaseProtocol = FetchBookingsUseCase()
  static let previewValue: FetchBookingsUseCaseProtocol = FetchBookingsUseCase()
  static let testValue: FetchBookingsUseCaseProtocol = FetchBookingsUseCase()
}

extension DependencyValues {
  var fetchBookingsUseCase: FetchBookingsUseCaseProtocol {
    get { self[FetchBookingsUseCaseKey.self] }
    set { self[FetchBookingsUseCaseKey.self] = newValue }
  }
}
