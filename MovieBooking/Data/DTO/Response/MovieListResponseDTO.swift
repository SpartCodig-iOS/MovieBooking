//
//  MovieListResponseDTO.swift
//  MovieBooking
//
//  Created by 김민희 on 10/15/25.
//

import Foundation

struct MovieListResponseDTO: Decodable {
  let page: Int
  let results: [MovieDTO]
  let totalPages: Int
  let totalResults: Int
  let dates: DatesDTO?
}

struct MovieDTO: Decodable {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String?
  let releaseDate: String
  let voteAverage: Double
}

struct DatesDTO: Decodable {
  let maximum: String
  let minimum: String
}
