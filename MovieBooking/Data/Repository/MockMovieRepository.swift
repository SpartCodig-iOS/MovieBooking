//
//  MockMovieRepository.swift
//  MovieBooking
//
//  Created by 김민희 on 10/15/25.
//

import Foundation

struct MockMovieRepository: MovieRepositoryProtocol {
  func fetchMovies() async throws -> [Movie] {
    try await Task.sleep(for: .seconds(1))
    return Movie.mockData
  }
}
