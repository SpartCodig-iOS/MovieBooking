//
//  MovieRepositoryProtocol.swift
//  MovieBooking
//
//  Created by 김민희 on 10/13/25.
//

import Foundation
import Dependencies

protocol MovieRepositoryProtocol {
  func fetchNowPlayingMovies() async throws -> [Movie]
  func fetchUpcomingMovies() async throws -> [Movie]
  func fetchPopularMovies() async throws -> [Movie]
  func fetchMovieDetail(id: String) async throws -> MovieDetail
}

private enum MovieRepositoryKey: DependencyKey {
  static let liveValue: any MovieRepositoryProtocol = MovieRepository()
  static let previewValue: any MovieRepositoryProtocol = MovieRepository()
  static let testValue: any MovieRepositoryProtocol = MockMovieRepository()
}

extension DependencyValues {
  var movieRepository: MovieRepositoryProtocol {
    get { self[MovieRepositoryKey.self] }
    set { self[MovieRepositoryKey.self] = newValue }
  }
}
