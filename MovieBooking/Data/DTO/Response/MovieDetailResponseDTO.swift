//
//  MovieDetailResponseDTO.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/15/25.
//

import Foundation

struct MovieDetailResponseDTO: Decodable {
  let id: Int
  let title: String
  let originalTitle: String
  let overview: String?
  let posterPath: String?
  let backdropPath: String?
  let releaseDate: String
  let runtime: Int
  let genres: [GenreDTO]
  let voteAverage: Double
  let voteCount: Int
  let popularity: Double
}

struct GenreDTO: Decodable {
  let id: Int
  let name: String
  
  func toDomain() -> Genre {
    return Genre(id: String(self.id), name: self.name)
  }
}

extension MovieDetailResponseDTO {
  func toDomain() -> MovieDetail {
    return MovieDetail(
      id: self.id,
      title: self.title,
      genres: self.genres.map { $0.toDomain() },  // 배열 전체 매핑
      releaseDate: releaseDate,
      runningTime: runtime * 60,  // minutes to seconds
      rating: voteAverage,
      posterPath: posterPath,
      summary: overview ?? "No overview available."
    )
  }
}
