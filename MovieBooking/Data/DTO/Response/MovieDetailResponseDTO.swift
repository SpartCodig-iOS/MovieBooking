//
//  MovieDetailResponseDTO.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/15/25.
//

import Foundation

struct MovieDetailResponseDTO: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let runtime: Int?
    let genres: [Genre]
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
}

// MARK: - Nested Types

extension MovieDetailResponseDTO {
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
}
