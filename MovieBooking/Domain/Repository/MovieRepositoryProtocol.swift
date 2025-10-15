//
//  MovieRepositoryProtocol.swift
//  MovieBooking
//
//  Created by 김민희 on 10/13/25.
//

import Foundation
import Dependencies

protocol MovieRepositoryProtocol {
  func fetchMovies() async throws -> [Movie]
}

private enum MovieRepositoryKey: DependencyKey {
  static let liveValue: any MovieRepositoryProtocol = MovieRepository()
  static let previewValue: any MovieRepositoryProtocol = MockMovieRepository()
  static let testValue: any MovieRepositoryProtocol = MockMovieRepository()
}

extension DependencyValues {
  var movieRepository: MovieRepositoryProtocol {
    get { self[MovieRepositoryKey.self] }
    set { self[MovieRepositoryKey.self] = newValue }
  }
}
