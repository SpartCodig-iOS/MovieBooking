//
//  MovieRepository.swift
//  MovieBooking
//
//  Created by 김민희 on 10/13/25.
//

import Foundation

final actor MovieRepository: MovieRepositoryProtocol {
  private let dataSource: MovieDataSource
  private var cachedMovies: [Movie] = []

  init(dataSource: MovieDataSource = DefaultMovieDataSource()) {
    self.dataSource = dataSource
  }

  func fetchMovies(for category: MovieCategory, page: Int = 1) async throws -> [Movie] {
    let dto = try await dataSource.movieList(category: category, page: page)
    let result = dto.results.map { $0.toDomain() }
    cachedMovies.append(contentsOf: result)
    return result
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
  
  func fetchMovieDetail(id: String) async throws -> MovieDetail {
    try await dataSource.movieDetail(id, MovieDetailRequestDTO()).toDomain()
  }
  
  func searchMovies(query searchText: String) async throws -> [Movie] {
    let trimmedKeyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    let aggregatedMovies = Array(Set(cachedMovies))
    guard !trimmedKeyword.isEmpty else { return [] }

    return aggregatedMovies.filter {
      $0.title.localizedCaseInsensitiveContains(trimmedKeyword)
    }
  }
}
