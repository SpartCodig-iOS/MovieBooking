//
//  BookingRepositoryProtocol.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation
import Dependencies

protocol BookingRepositoryProtocol {
  func createBooking(_ bookingInfo: BookingInfo) async throws -> BookingInfo
  func fetchBookings() async throws -> [BookingInfo]
  func deleteBooking(id: String) async throws
}

private enum BookingRepositoryKey: DependencyKey {
  static let liveValue: any BookingRepositoryProtocol = BookingRepository()
  static let previewValue: any BookingRepositoryProtocol = BookingRepository()
  static let testValue: any BookingRepositoryProtocol = BookingRepository()
}

extension DependencyValues {
  var bookingRepository: BookingRepositoryProtocol {
    get { self[BookingRepositoryKey.self] }
    set { self[BookingRepositoryKey.self] = newValue }
  }
}
