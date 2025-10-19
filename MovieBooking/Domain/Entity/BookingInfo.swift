//
//  BookingInfo.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation

struct BookingInfo: Identifiable, Codable, Equatable {
  let id: String
  let movieId: String
  let movieTitle: String
  let posterPath: String
  let theaterId: Int
  let theaterName: String
  let showTime: String
  let numberOfPeople: Int
  let totalPrice: Int
  let bookedAt: Date

  init(
    id: String = UUID().uuidString,
    movieId: String,
    movieTitle: String,
    posterPath: String,
    theaterId: Int,
    theaterName: String,
    showTime: String,
    numberOfPeople: Int,
    totalPrice: Int,
    bookedAt: Date = Date()
  ) {
    self.id = id
    self.movieId = movieId
    self.movieTitle = movieTitle
    self.posterPath = posterPath
    self.theaterId = theaterId
    self.theaterName = theaterName
    self.showTime = showTime
    self.numberOfPeople = numberOfPeople
    self.totalPrice = totalPrice
    self.bookedAt = bookedAt
  }
}
