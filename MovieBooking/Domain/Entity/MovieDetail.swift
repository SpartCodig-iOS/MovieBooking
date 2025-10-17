//
//  MovieDetail.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/16/25.
//

import Foundation

struct MovieDetail {
  let title: String
  let genres: String
  let releaseDate: Date?
  let runningTime: Int
  let rating: Double
  let posterPath: String?
  let summary: String
  
  init(
    title: String,
    genres: String,
    releaseDate: String,
    runningTime: Int,
    rating: Double,
    posterPath: String?,
    summary: String
  ) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd."
    
    self.title = title
    self.genres = genres
    self.releaseDate = dateFormatter.date(from: releaseDate)
    self.runningTime = runningTime
    self.rating = rating
    self.posterPath = posterPath
    self.summary = summary
  }
}

extension MovieDetail {
  static let mockData: MovieDetail = MovieDetail(
    title: "The Shawshank Redemption",
    genres: "Drama",
    releaseDate: "1994-9-23.",
    runningTime: 142 * 60,
    rating: 8.7,
    posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg",
    summary: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency."
  )
}
