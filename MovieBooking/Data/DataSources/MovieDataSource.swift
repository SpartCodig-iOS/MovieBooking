//
//  MovieDataSource.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/15/25.
//

import Foundation

protocol MovieDataSource {
    func movieDetail(_ id: String, _ request: MovieDetailRequestDTO) async throws -> MovieDetailResponseDTO
    func movieList(category: MovieCategory, page: Int) async throws -> MovieListResponseDTO
}

struct DefaultMovieDataSource: MovieDataSource {
    private let provider: NetworkProvider
    
    public init() {
        self.provider = NetworkProvider.default
    }
    
    func movieDetail(
        _ id: String,
        _ request: MovieDetailRequestDTO = MovieDetailRequestDTO()
    ) async throws -> MovieDetailResponseDTO {
        try await provider.request(MovieTarget.movieDetail(id: id, request: request))
    }

  func movieList(
      category: MovieCategory,
      page: Int = 1
  ) async throws -> MovieListResponseDTO {
      try await provider.request(MovieTarget.movieList(category: category, page: page))
  }
}

extension MovieTarget: TargetType {
    var baseURL: String {
        return APIConfiguration.baseURL
    }
    
    var path: String {
        switch self {
        case .movieDetail(let id, _):
            return "/\(id)"
        case .movieList(let category, _):
            return "/\(category.rawValue)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .movieDetail:
            return .get
        case .movieList:
            return .get
        }
    }
    
    var parameters: RequestParameter? {
        switch self {
        case .movieDetail(_, let request):
          return .query(request)

        case .movieList(_ , let page):
          return .query(["page": page])
        }
    }
    
    var headers: HTTPHeaders {
        var header = HTTPHeaders()
        header.add(.accept(.json))
        header.add(.authorization(bearerToken: APIConfiguration.apiKey))
        return header
    }
}
