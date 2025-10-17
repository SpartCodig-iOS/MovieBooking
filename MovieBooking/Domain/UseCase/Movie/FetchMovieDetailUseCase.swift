//
//  FetchMovieDetailUseCase.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import Foundation
import Dependencies

protocol FetchMovieDetailUseCaseProtocol {
  func execute(_ id: String) async throws -> MovieDetail
}

struct FetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {
  @Dependency(\.movieRepository) var repository: MovieRepositoryProtocol
  
  func execute(_ id: String) async throws -> MovieDetail {
    return MovieDetail.mockData
  }
}

private enum FetchMovieDetailUseCaseKey: DependencyKey {
  static let liveValue: any FetchMovieDetailUseCaseProtocol = FetchMovieDetailUseCase()
  static let previewValue: any FetchMovieDetailUseCaseProtocol = MockFetchMovieDetailUseCase()
  static let testValue: any FetchMovieDetailUseCaseProtocol = MockFetchMovieDetailUseCase()
}

extension DependencyValues {
  var fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {
    get { self[FetchMovieDetailUseCaseKey.self] }
    set { self[FetchMovieDetailUseCaseKey.self] = newValue }
  }
}

struct MockFetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {
  func execute(_ id: String) async throws -> MovieDetail {
    return MovieDetail.mockData
  }
}
