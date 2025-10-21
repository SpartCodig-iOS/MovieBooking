//
//  SearchMovieUseCase.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/21/25.
//

import Foundation
import Dependencies

protocol SearchMovieUseCaseProtocol {
  func execute(_ searchText: String) async throws -> [Movie]
}

struct SearchMovieUseCase: SearchMovieUseCaseProtocol {
  @Dependency(\.movieRepository) var repository
  
  func execute(_ searchText: String) async throws -> [Movie] {
    return try await repository.searchMovies(query: searchText)
  }
}

private enum SearchMovieUseCaseKey: DependencyKey {
  static let liveValue: SearchMovieUseCaseProtocol = SearchMovieUseCase()
  static let previewValue: SearchMovieUseCaseProtocol = SearchMovieUseCase()
  static let testValue: SearchMovieUseCaseProtocol = SearchMovieUseCase()
}

extension DependencyValues {
  var searchMovieUseCase: SearchMovieUseCaseProtocol {
    get { self[SearchMovieUseCaseKey.self] }
    set { self[SearchMovieUseCaseKey.self] = newValue }
  }
}
