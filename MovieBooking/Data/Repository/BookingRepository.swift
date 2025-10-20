//
//  BookingRepository.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation

struct BookingRepository: BookingRepositoryProtocol {
  private let dataSource: BookingDataSourceProtocol

  init(dataSource: BookingDataSourceProtocol = LocalBookingDataSource()) {
    self.dataSource = dataSource
  }

  func createBooking(_ bookingInfo: BookingInfo) async throws -> BookingInfo {
    try await dataSource.saveBooking(bookingInfo)
  }

  func fetchBookings() async throws -> [BookingInfo] {
    try await dataSource.fetchAllBookings()
  }

  func deleteBooking(id: String) async throws {
    try await dataSource.deleteBooking(id: id)
  }
}
