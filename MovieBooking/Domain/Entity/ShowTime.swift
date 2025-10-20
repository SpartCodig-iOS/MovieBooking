//
//  ShowTime.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation

struct ShowTime: Identifiable, Codable, Sendable {
  let id: String
  let date: Date
  let time: String

  init(id: String = UUID().uuidString, date: Date, time: String) {
    self.id = id
    self.date = date
    self.time = time
  }

  /// 표시용 날짜 문자열 (예: "2025년 10월 20일")
  var displayDate: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter.string(from: date)
  }

  /// 표시용 요일 (예: "월요일")
  var displayWeekday: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "EEEE"
    return formatter.string(from: date)
  }

  /// 표시용 짧은 날짜 (예: "10/20 (월)")
  var displayShortDate: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M/d"
    let dateStr = formatter.string(from: date)

    formatter.dateFormat = "E"
    let weekdayStr = formatter.string(from: date)

    return "\(dateStr) (\(weekdayStr))"
  }

  /// 전체 표시 (예: "2025년 10월 20일 14:30")
  var fullDisplay: String {
    "\(displayDate) \(time)"
  }
}

extension ShowTime: Equatable {
  nonisolated static func == (lhs: ShowTime, rhs: ShowTime) -> Bool {
    lhs.id == rhs.id && lhs.date == rhs.date && lhs.time == rhs.time
  }
}
