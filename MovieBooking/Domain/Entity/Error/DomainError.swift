//
//  DomainError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation

public enum DomainError: Error, Equatable {
  // MARK: - Common
  case networkUnavailable
  case notFound
  case rateLimited(retryAfter: TimeInterval?)
  case validationFailed([String])
  case dependencyUnavailable
  case authenticationFailed
  case unauthorized
  case unknown
}

// MARK: - 사용자 메시지 (UI friendly)
extension DomainError: LocalizedError {
  public var errorDescription: String? {
    switch self {
        // MARK: - Network
      case .networkUnavailable:
        return "네트워크 연결을 확인해주세요."

        // MARK: - Common
      case .notFound:
        return "요청한 데이터를 찾을 수 없습니다."

      case .rateLimited(let retryAfter):
        if let s = retryAfter {
          return "요청이 너무 많습니다. \(Int(s))초 후 다시 시도해주세요."
        }
        return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요."

      case .validationFailed(let fields):
        return fields.isEmpty
        ? "입력값이 올바르지 않습니다."
        : "\(fields.joined(separator: ", ")) 항목을 확인해주세요."

        // MARK: - Auth
      case .authenticationFailed:
        return "인증에 실패했습니다. 다시 로그인해주세요."

      case .unauthorized:
        return "접근 권한이 없습니다. 다시 로그인하거나 관리자에게 문의하세요."

        // MARK: - System
      case .dependencyUnavailable:
        return "서비스를 사용할 수 없습니다. 잠시 후 다시 시도해주세요."

      case .unknown:
        return "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
    }
  }
}
