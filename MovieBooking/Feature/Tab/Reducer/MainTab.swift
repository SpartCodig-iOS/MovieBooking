//
//  MainTab.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import Foundation


public enum MainTab: String, CaseIterable, Sendable {
  case home, book, tickets, theaters, my
}

// 메인 액터 격리에서 분리된 동치/해시 구현
extension MainTab: Equatable, Hashable {
  nonisolated public static func == (lhs: MainTab, rhs: MainTab) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
  nonisolated public func hash(into hasher: inout Hasher) {
    hasher.combine(self.rawValue)
  }
}
