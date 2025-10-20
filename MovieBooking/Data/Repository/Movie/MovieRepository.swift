//
//  MovieRepository.swift
//  MovieBooking
//
//  Created by 김민희 on 10/13/25.
//

import Foundation

struct MovieRepository: MovieRepositoryProtocol {
  private let dataSource: MovieDataSource

  init(dataSource: MovieDataSource = DefaultMovieDataSource()) {
    self.dataSource = dataSource
  }

  func fetchMovies(for category: MovieCategory, page: Int = 1) async throws -> [Movie] {
    let dto = try await dataSource.movieList(category: category, page: page)
    return dto.results.map { $0.toDomain() }
  }

  func fetchNowPlayingMovies() async throws -> [Movie] {
    try await fetchMovies(for: .nowPlaying)
  }

  func fetchUpcomingMovies() async throws -> [Movie] {
    try await fetchMovies(for: .upcoming)
  }

  func fetchPopularMovies() async throws -> [Movie] {
    try await fetchMovies(for: .popular)
  }
}
