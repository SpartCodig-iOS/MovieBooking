//
//  FetchMovieTimesUseCase.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/18/25.
//

import Foundation
import Dependencies

protocol FetchMovieTimesUseCaseProtocol {
  func execute(
    _ movieId: String,
    at theaterId: Int
  ) async throws -> [ShowTime]
}

struct FetchMovieTimesUseCase: FetchMovieTimesUseCaseProtocol {
  func execute(
    _ movieId: String,
    at theaterId: Int
  ) async throws -> [ShowTime] {
    try await Task.sleep(nanoseconds: 300_000_000) // 0.3초 딜레이

    // movieId와 theaterId를 시드로 사용하여 일관된 랜덤 결과 생성
    let seed = (movieId.hashValue &+ theaterId) & 0x7FFFFFFF
    var generator = SeededRandomGenerator(seed: UInt64(seed))

    // 가능한 상영 시간대 (30분 간격)
    let possibleTimes = [
      "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
      "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
      "15:00", "15:30", "16:00", "16:30", "17:00", "17:30",
      "18:00", "18:30", "19:00", "19:30", "20:00", "20:30",
      "21:00", "21:30", "22:00", "22:30", "23:00", "23:30"
    ]

    // 향후 7일 중 랜덤 날짜 생성 (3~5일 사이)
    let daysAhead = Int(generator.next() % 3) + 3 // 3~5일 후
    let calendar = Calendar.current
    let showDate = calendar.date(byAdding: .day, value: daysAhead, to: Date())!

    // 랜덤하게 4~8개의 상영 시간 선택
    let timeCount = Int(generator.next() % 5) + 4 // 4~8
    var selectedIndices = Set<Int>()

    while selectedIndices.count < timeCount {
      let index = Int(generator.next() % UInt64(possibleTimes.count))
      selectedIndices.insert(index)
    }

    return selectedIndices.sorted().map { index in
      ShowTime(date: showDate, time: possibleTimes[index])
    }
  }
}

// 시드 기반 랜덤 생성기 (동일한 movieId + theaterId 조합에 대해 일관된 결과 제공)
private struct SeededRandomGenerator {
  private var state: UInt64

  init(seed: UInt64) {
    self.state = seed == 0 ? 1 : seed
  }

  mutating func next() -> UInt64 {
    // LCG (Linear Congruential Generator) -> 자세히는 모르겠음
    state = (state &* 6364136223846793005) &+ 1442695040888963407
    return state
  }
}

private enum FetchMovieTimesUseCaseKey: DependencyKey {
  static let liveValue: FetchMovieTimesUseCaseProtocol = FetchMovieTimesUseCase()
  static let previewValue: any FetchMovieTimesUseCaseProtocol = FetchMovieTimesUseCase()
  static let testValue: any FetchMovieTimesUseCaseProtocol = FetchMovieTimesUseCase()
}

extension DependencyValues {
  var fetchMovieTimesUseCase: FetchMovieTimesUseCaseProtocol {
    get { self[FetchMovieTimesUseCaseKey.self] }
    set { self[FetchMovieTimesUseCaseKey.self] = newValue }
  }
}
