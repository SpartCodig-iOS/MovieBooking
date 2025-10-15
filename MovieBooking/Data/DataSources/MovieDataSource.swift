//
//  MovieDataSource.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/15/25.
//

import Foundation

protocol MovieDataSource {
    func movieDetail(_ id: String) async throws -> MovieDetailResponseDTO
}

struct DefaultMovieDataSource: MovieDataSource {
    private let provider: NetworkProvider
    
    public init() {
        self.provider = NetworkProvider.default
    }
    
    func movieDetail(
        _ id: String
    ) async throws -> MovieDetailResponseDTO {
        try await provider.request(MovieTarget.movieDetail(id: id))
    }
}

enum MovieTarget {
    case movieDetail(id: String)
}

extension MovieTarget: TargetType {
    var baseURL: String {
        return APIConfiguration.baseURL
    }
    
    var path: String {
        switch self {
        case .movieDetail(let id):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .movieDetail:
            return .get
        }
    }
    
    var parameters: RequestParameter? {
        switch self {
        case .movieDetail:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        var header = HTTPHeaders()
        header.add(.accept(.json))
        header.add(.authorization(bearerToken: APIConfiguration.apiKey))
        return header
    }
}
