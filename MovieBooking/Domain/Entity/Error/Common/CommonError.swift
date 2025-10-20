//
//  CommonError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation

/// 공통 에러 (정말 공통으로 사용되는 에러만)
///
/// ⚠️ 주의: 특정 도메인에 속하는 에러는 각 도메인 에러를 사용하세요
/// - 네트워크 에러 → NetworkError
/// - 데이터 에러 → DataError
/// - 유효성 검사 에러 → ValidationError
/// - 시스템 에러 → SystemError
public enum CommonError: Error, Equatable {
  /// 알 수 없는 에러 (최후의 수단)
  case unknown(message: String? = nil)

  /// 취소된 작업
  case cancelled

  /// 지원되지 않는 기능
  case unsupported(feature: String? = nil)
}

// MARK: - 사용자 메시지 (UI friendly)
extension CommonError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .unknown(let message):
      if let message = message {
        return "알 수 없는 오류가 발생했습니다: \(message)"
      }
      return "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요."

    case .cancelled:
      return "작업이 취소되었습니다."

    case .unsupported(let feature):
      if let feature = feature {
        return "\(feature) 기능은 지원되지 않습니다."
      }
      return "지원되지 않는 기능입니다."
    }
  }
}
