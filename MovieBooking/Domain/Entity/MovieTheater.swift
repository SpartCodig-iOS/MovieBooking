//
//  MovieTheater.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/18/25.
//

import Foundation

struct MovieTheater: Identifiable, Sendable {
  let id: Int
  let name: String
}

extension MovieTheater: Equatable {
  nonisolated static func == (lhs: MovieTheater, rhs: MovieTheater) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name
  }
}
