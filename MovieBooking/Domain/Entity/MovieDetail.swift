//
//  MovieDetail.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/16/25.
//

import Foundation

struct MovieDetail {
  let title: String
  let genres: [Genre]  // 배열로 변경
  let releaseDate: Date?
  let runningTime: Int
  let rating: Double
  let posterPath: String?
  let summary: String
  let ticketPrice: Int  // 티켓 가격

  init(
    title: String,
    genres: [Genre],  // 배열로 변경
    releaseDate: String,
    runningTime: Int,
    rating: Double,
    posterPath: String?,
    summary: String,
    ticketPrice: Int = 13000  // 기본값 13,000원
  ) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    self.title = title
    self.genres = genres
    self.releaseDate = dateFormatter.date(from: releaseDate)
    self.runningTime = runningTime
    self.rating = rating
    self.posterPath = posterPath
    self.summary = summary
    self.ticketPrice = ticketPrice
  }
}

struct Genre {
  let id: String
  let name: String
}

extension MovieDetail {
  static let mockData: MovieDetail = MovieDetail(
    title: "The Shawshank Redemption",
    genres: [
      Genre(id: "18", name: "드라마"),
      Genre(id: "80", name: "범죄")
    ],
    releaseDate: "1994-09-23",
    runningTime: 142 * 60,
    rating: 8.7,
    posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg",
    summary: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency."
  )
}
