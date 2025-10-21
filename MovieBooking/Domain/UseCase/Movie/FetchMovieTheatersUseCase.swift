//
//  FetchMovieTheatersUseCase.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/18/25.
//

import Foundation
import Dependencies

protocol FetchMovieTheatersUseCaseProtocol {
  func execute(_ movieId: String) async throws -> [MovieTheater]
}

struct FetchMovieTheatersUseCase: FetchMovieTheatersUseCaseProtocol {
  func execute(_ movieId: String) async throws -> [MovieTheater] {
    try await Task.sleep(nanoseconds: 500_000_000) // 0.5초 딜레이

    let allTheaters = [
      MovieTheater(id: 1, name: "CGV 강남"),
      MovieTheater(id: 2, name: "CGV 용산아이파크몰"),
      MovieTheater(id: 3, name: "CGV 명동역 씨네라이브러리"),
      MovieTheater(id: 4, name: "CGV 여의도"),
      MovieTheater(id: 5, name: "CGV 왕십리"),
      MovieTheater(id: 6, name: "CGV 건대입구"),
      MovieTheater(id: 7, name: "CGV 강변"),
      MovieTheater(id: 8, name: "CGV 목동"),
      MovieTheater(id: 9, name: "CGV 천호"),
      MovieTheater(id: 10, name: "CGV 송파"),
      MovieTheater(id: 11, name: "CGV 잠실"),
      MovieTheater(id: 12, name: "CGV 구로"),
      MovieTheater(id: 13, name: "롯데시네마 월드타워"),
      MovieTheater(id: 14, name: "롯데시네마 홍대입구"),
      MovieTheater(id: 15, name: "롯데시네마 건대입구"),
      MovieTheater(id: 16, name: "롯데시네마 김포공항"),
      MovieTheater(id: 17, name: "롯데시네마 가산디지털"),
      MovieTheater(id: 18, name: "롯데시네마 영등포"),
      MovieTheater(id: 19, name: "롯데시네마 노원"),
      MovieTheater(id: 20, name: "롯데시네마 수락산"),
      MovieTheater(id: 21, name: "롯데시네마 서울대입구"),
      MovieTheater(id: 22, name: "롯데시네마 합정"),
      MovieTheater(id: 23, name: "롯데시네마 청량리"),
      MovieTheater(id: 24, name: "롯데시네마 동대문"),
      MovieTheater(id: 25, name: "메가박스 코엑스"),
      MovieTheater(id: 26, name: "메가박스 강남"),
      MovieTheater(id: 27, name: "메가박스 이수"),
      MovieTheater(id: 28, name: "메가박스 상봉"),
      MovieTheater(id: 29, name: "메가박스 센트럴"),
      MovieTheater(id: 30, name: "메가박스 신촌"),
      MovieTheater(id: 31, name: "메가박스 목동"),
      MovieTheater(id: 32, name: "메가박스 성수"),
      MovieTheater(id: 33, name: "메가박스 동대문"),
      MovieTheater(id: 34, name: "메가박스 군자"),
      MovieTheater(id: 35, name: "메가박스 은평"),
      MovieTheater(id: 36, name: "메가박스 화곡"),
      MovieTheater(id: 37, name: "CGV 압구정"),
      MovieTheater(id: 38, name: "CGV 청담씨네시티"),
      MovieTheater(id: 39, name: "CGV 대학로"),
      MovieTheater(id: 40, name: "CGV 피카디리1958"),
      MovieTheater(id: 41, name: "CGV 용산"),
      MovieTheater(id: 42, name: "CGV 서면삼정타워"),
      MovieTheater(id: 43, name: "CGV 센텀시티"),
      MovieTheater(id: 44, name: "CGV 해운대"),
      MovieTheater(id: 45, name: "CGV 대연"),
      MovieTheater(id: 46, name: "롯데시네마 부산본점"),
      MovieTheater(id: 47, name: "롯데시네마 사상"),
      MovieTheater(id: 48, name: "롯데시네마 오투"),
      MovieTheater(id: 49, name: "메가박스 해운대"),
      MovieTheater(id: 50, name: "메가박스 장산"),
    ]

    // 랜덤하게 15~30개 극장 선택
    let randomCount = Int.random(in: 15...30)
    return allTheaters.shuffled().prefix(randomCount).sorted { $0.id < $1.id }
  }
}

private enum FetchMovieTheatersUseCaseKey: DependencyKey {
  static let liveValue: FetchMovieTheatersUseCaseProtocol = FetchMovieTheatersUseCase()
  static let previewValue: any FetchMovieTheatersUseCaseProtocol = FetchMovieTheatersUseCase()
  static let testValue: any FetchMovieTheatersUseCaseProtocol = FetchMovieTheatersUseCase()
}

extension DependencyValues {
  var fetchMovieTheatersUseCase: FetchMovieTheatersUseCaseProtocol {
    get { self[FetchMovieTheatersUseCaseKey.self] }
    set { self[FetchMovieTheatersUseCaseKey.self] = newValue }
  }
}
