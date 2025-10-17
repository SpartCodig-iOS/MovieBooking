//
//  MockMovieRepository.swift
//  MovieBooking
//
//  Created by 김민희 on 10/15/25.
//

import Foundation

struct MockMovieRepository: MovieRepositoryProtocol {
  func fetchUpcomingMovies() async throws -> [Movie] {
    return Movie.mockData
  }

  func fetchPopularMovies() async throws -> [Movie] {
    return Movie.mockData
  }
  
  func fetchNowPlayingMovies() async throws -> [Movie] {
    try await Task.sleep(for: .seconds(1))
    return Movie.mockData
  }
  
  func fetchMovieDetail(id: String) async throws -> MovieDetail {
    return MovieDetail.mockData
  }
}
