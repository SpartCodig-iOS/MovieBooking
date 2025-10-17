//
//  MovieDetailError.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import Foundation

enum MovieDetailError: Error {
  case networkError(NetworkError)
  case movieNotFound
  case unknown(Error)

  init(from error: Error) {
    if let networkError = error as? NetworkError {
      switch networkError {
      case .httpError(let statusCode, _, _) where statusCode == 404:
        self = .movieNotFound
      default:
        self = .networkError(networkError)
      }
    } else {
      self = .unknown(error)
    }
  }
}

extension MovieDetailError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .networkError(let networkError):
      return networkError.errorDescription
    case .movieNotFound:
      return "영화 정보를 찾을 수 없습니다"
    case .unknown(let error):
      return "알 수 없는 오류: \(error.localizedDescription)"
    }
  }

  var title: String {
    switch self {
    case .networkError(let networkError):
      switch networkError {
      case .invalidURL, .invalidResponse:
        return "잘못된 요청"
      case .noData:
        return "데이터 없음"
      case .httpError(let statusCode, _, _):
        if statusCode >= 500 {
          return "서버 오류"
        } else {
          return "네트워크 오류"
        }
      case .decodingError:
        return "데이터 오류"
      case .encodingError:
        return "요청 오류"
      case .unknown:
        return "알 수 없는 오류"
      }
    case .movieNotFound:
      return "영화 없음"
    case .unknown:
      return "오류 발생"
    }
  }
}
