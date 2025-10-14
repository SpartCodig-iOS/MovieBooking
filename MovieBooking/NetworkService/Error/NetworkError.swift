//
//  NetworkError.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/13/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL         // 유효하지 않은 URL
    case noData             // 응답 데이터가 없음
    case invalidResponse    // HTTPResponse가 아님
    case httpError(statusCode: Int) // HTTTP 에러 (400, 500 등)
    case decodingError(Error)      // JSON 파싱 에러
    case encodingError(Error)
    case unknown(Error)     // 예상하지 못한 에러
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다"
        case .noData:
            return "응답 데이터가 없습니다"
        case .invalidResponse:
            return "올바르지 않은 응답입니다"
        case .httpError(let statusCode):
            return "HTTP 에러: \(statusCode)"
        case .decodingError:
            return "데이터 파싱에 실패했습니다"
        case .encodingError:
            return "데이터 인코딩에 실패했습니다"
        case .unknown(let error):
            return "알 수 없는 에러: \(error.localizedDescription)"
        }
    }
}
