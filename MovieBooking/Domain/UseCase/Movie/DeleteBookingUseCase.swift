//
//  DeleteBookingUseCase.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/20/25.
//

import Foundation
import Dependencies

protocol DeleteBookingUseCaseProtocol {
  func execute(id: String) async throws
}

struct DeleteBookingUseCase: DeleteBookingUseCaseProtocol {
  @Dependency(\.bookingRepository) var repository

  func execute(id: String) async throws {
    try await Task.sleep(nanoseconds: 300_000_000) // 0.3초
    try await repository.deleteBooking(id: id)
  }
}

private enum DeleteBookingUseCaseKey: DependencyKey {
  static let liveValue: DeleteBookingUseCaseProtocol = DeleteBookingUseCase()
  static let previewValue: DeleteBookingUseCaseProtocol = DeleteBookingUseCase()
  static let testValue: DeleteBookingUseCaseProtocol = DeleteBookingUseCase()
}

extension DependencyValues {
  var deleteBookingUseCase: DeleteBookingUseCaseProtocol {
    get { self[DeleteBookingUseCaseKey.self] }
    set { self[DeleteBookingUseCaseKey.self] = newValue }
  }
}
