//
//  MovieTheater.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/18/25.
//

import Foundation

public struct MovieTheater: Identifiable, Sendable, Hashable {
  public let id: Int
  let name: String
  
  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

extension MovieTheater: Equatable {
  nonisolated public static func == (lhs: MovieTheater, rhs: MovieTheater) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name
  }
}
