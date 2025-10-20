//
//  CreateBookingUseCase.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation
import Dependencies

protocol CreateBookingUseCaseProtocol {
  func execute(_ bookingInfo: BookingInfo) async throws -> BookingInfo
}

struct CreateBookingUseCase: CreateBookingUseCaseProtocol {
  @Dependency(\.bookingRepository) var repository

  func execute(_ bookingInfo: BookingInfo) async throws -> BookingInfo {
    // 간단한 딜레이로 네트워크 호출 시뮬레이션
    try await Task.sleep(nanoseconds: 500_000_000) // 0.5초

    // Repository를 통해 저장
    return try await repository.createBooking(bookingInfo)
  }
}

private enum CreateBookingUseCaseKey: DependencyKey {
  static let liveValue: CreateBookingUseCaseProtocol = CreateBookingUseCase()
  static let previewValue: CreateBookingUseCaseProtocol = CreateBookingUseCase()
  static let testValue: CreateBookingUseCaseProtocol = CreateBookingUseCase()
}

extension DependencyValues {
  var createBookingUseCase: CreateBookingUseCaseProtocol {
    get { self[CreateBookingUseCaseKey.self] }
    set { self[CreateBookingUseCaseKey.self] = newValue }
  }
}
