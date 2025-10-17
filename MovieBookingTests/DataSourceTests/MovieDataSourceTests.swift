//
//  MovieDataSourceTests.swift
//  MovieBookingTests
//
//  Created by 홍석현 on 10/15/25.
//

import Testing
@testable import MovieBooking

struct MovieDataSourceTests {

    // TODO: - 나중에 제거
    @Test("영화 상세 정보 조회 테스트 실 네트워크 테스트")
    func fetchMovieDetailTest() async throws {
        let dataSource = DefaultMovieDataSource()
        let response = try await dataSource.movieDetail("2")
        #expect(response.title == "Ariel")
    }

}
