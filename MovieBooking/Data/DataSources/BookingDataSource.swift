//
//  BookingDataSource.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation

protocol BookingDataSourceProtocol {
  func saveBooking(_ bookingInfo: BookingInfo) async throws -> BookingInfo
  func fetchAllBookings() async throws -> [BookingInfo]
  func deleteBooking(id: String) async throws
}

final class LocalBookingDataSource: BookingDataSourceProtocol {
  private let userDefaults: UserDefaults
  private let bookingsKey = "com.moviebooking.bookings"

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }

  func saveBooking(_ bookingInfo: BookingInfo) async throws -> BookingInfo {
    var bookings = try await fetchAllBookings()
    bookings.append(bookingInfo)

    let encoder = JSONEncoder()
    let data = try encoder.encode(bookings)
    userDefaults.set(data, forKey: bookingsKey)

    return bookingInfo
  }

  func fetchAllBookings() async throws -> [BookingInfo] {
    guard let data = userDefaults.data(forKey: bookingsKey) else {
      return []
    }

    let decoder = JSONDecoder()
    return try decoder.decode([BookingInfo].self, from: data)
  }

  func deleteBooking(id: String) async throws {
    var bookings = try await fetchAllBookings()
    bookings.removeAll { $0.id == id }

    let encoder = JSONEncoder()
    let data = try encoder.encode(bookings)
    userDefaults.set(data, forKey: bookingsKey)
  }
}
