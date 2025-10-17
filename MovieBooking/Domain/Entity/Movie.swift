//
//  Movie.swift
//  MovieBooking
//
//  Created by 김민희 on 10/13/25.
//

import Foundation

public struct Movie: Identifiable, Equatable {
  public let id: Int
  public let title: String
  public let overview: String
  public let posterPath: String?
  public let releaseDate: String
  public let voteAverage: Double

  public init(
    id: Int,
    title: String,
    overview: String,
    posterPath: String?,
    releaseDate: String,
    voteAverage: Double
  ) {
    self.id = id
    self.title = title
    self.overview = overview
    self.posterPath = posterPath
    self.releaseDate = releaseDate
    self.voteAverage = voteAverage
  }
}


extension Movie {
  static let mock1 = Movie(id: 1, title: "TCA 대모험", overview: "한 개발자의 TCA 입문기...", posterPath: "/path1.jpg", releaseDate: "2025-01-01", voteAverage: 2)
  static let mock2 = Movie(id: 2, title: "클린 아키텍처의 비밀", overview: "레이어를 분리하며 벌어지는 미스터리...", posterPath: "/path2.jpg", releaseDate: "2025-01-02", voteAverage: 4)
  static let mock3 = Movie(id: 3, title: "SwiftUI 애니메이션", overview: "뷰가 살아 움직인다!", posterPath: "/path3.jpg", releaseDate: "2025-01-03", voteAverage: 5)

  static let mockData: [Movie] = [mock1, mock2, mock3]
}
