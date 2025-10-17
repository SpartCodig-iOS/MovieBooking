//
//  CommonError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation

/// 공통 에러 (네트워크 등 전역에서 공유되는 경우에만 사용)
public enum CommonError: Error, Equatable {
  case networkUnavailable
  case requestTimeout
  case serverError(statusCode: Int)
  case rateLimited(retryAfter: TimeInterval?)
  case unknown(message: String? = nil)
}

// MARK: - 사용자 메시지 (UI friendly)
extension CommonError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .networkUnavailable:
      return "네트워크 연결을 확인해주세요."

    case .requestTimeout:
      return "요청 시간이 초과되었습니다. 다시 시도해주세요."

    case .serverError(let statusCode):
      return "서버 오류가 발생했습니다(코드: \(statusCode)). 잠시 후 다시 시도해주세요."

    case .rateLimited(let retryAfter):
      if let seconds = retryAfter {
        return "요청이 너무 많습니다. \(Int(seconds))초 후 다시 시도해주세요."
      }
      return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요."

    case .unknown(let message):
      if let message = message {
        return "알 수 없는 오류가 발생했습니다: \(message)"
      }
      return "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
    }
  }
}
