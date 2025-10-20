//
//  BookingInfo.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation

public struct BookingInfo: Identifiable, Codable, Equatable {
  public let id: String
  let movieId: String
  let movieTitle: String
  let posterPath: String
  let theaterId: Int
  let theaterName: String
  let showDate: Date        // 상영 날짜
  let showTime: String      // 상영 시간 (예: "14:30")
  let numberOfPeople: Int
  let totalPrice: Int
  let bookedAt: Date        // 예매한 날짜

  public init(
    id: String = UUID().uuidString,
    movieId: String,
    movieTitle: String,
    posterPath: String,
    theaterId: Int,
    theaterName: String,
    showDate: Date,
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
    self.showDate = showDate
    self.showTime = showTime
    self.numberOfPeople = numberOfPeople
    self.totalPrice = totalPrice
    self.bookedAt = bookedAt
  }

  /// 표시용 상영 날짜 (예: "2025년 10월 20일")
  var displayShowDate: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월 d일 (E)"
    return formatter.string(from: showDate)
  }

  /// 전체 상영 정보 (예: "2025년 10월 20일 14:30")
  var fullShowDateTime: String {
    "\(displayShowDate) \(showTime)"
  }
}
