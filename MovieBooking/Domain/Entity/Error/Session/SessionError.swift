//
//  SessionError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import Supabase

/// Session 도메인 전용 에러 (세션 관리)
public enum SessionError: Error, Equatable {
  // MARK: - 세션 조회 관련
  case sessionNotFound
  case sessionExpired
  case sessionInvalid
  case sessionRetrievalFailed

  // MARK: - 세션 대기 관련
  case sessionWaitTimeout(timeout: TimeInterval)
  case sessionWaitCancelled
  case sessionEventStreamFailed

  // MARK: - 토큰 관련
  case tokenExpired
  case tokenRefreshFailed(reason: String? = nil)
  case tokenValidationFailed
  case tokenMissing

  // MARK: - 세션 상태 관련
  case sessionStateInvalid
  case sessionRefreshInProgress
  case multipleSessionsDetected
}

// MARK: - 사용자 메시지 (UI friendly)
extension SessionError: LocalizedError {
  public var errorDescription: String? {
    switch self {
      // MARK: - 세션 조회 관련
    case .sessionNotFound:
      return "로그인 정보를 찾을 수 없습니다. 다시 로그인해주세요."

    case .sessionExpired:
      return "로그인이 만료되었습니다. 다시 로그인해주세요."

    case .sessionInvalid:
      return "로그인 정보가 올바르지 않습니다. 다시 로그인해주세요."

    case .sessionRetrievalFailed:
      return "로그인 정보를 가져올 수 없습니다. 네트워크를 확인해주세요."

      // MARK: - 세션 대기 관련
    case .sessionWaitTimeout(let timeout):
      return "로그인 대기 시간이 초과되었습니다(\(Int(timeout))초). 다시 시도해주세요."

    case .sessionWaitCancelled:
      return "로그인이 취소되었습니다."

    case .sessionEventStreamFailed:
      return "로그인 상태 확인 중 오류가 발생했습니다."

      // MARK: - 토큰 관련
    case .tokenExpired:
      return "인증 토큰이 만료되었습니다. 다시 로그인해주세요."

    case .tokenRefreshFailed(let reason):
      if let reason = reason {
        return "인증 토큰 갱신에 실패했습니다: \(reason)"
      }
      return "인증 토큰 갱신에 실패했습니다. 다시 로그인해주세요."

    case .tokenValidationFailed:
      return "인증 토큰이 올바르지 않습니다."

    case .tokenMissing:
      return "인증 토큰이 없습니다. 로그인해주세요."

      // MARK: - 세션 상태 관련
    case .sessionStateInvalid:
      return "로그인 상태가 올바르지 않습니다. 다시 로그인해주세요."

    case .sessionRefreshInProgress:
      return "로그인 정보를 갱신 중입니다. 잠시만 기다려주세요."

    case .multipleSessionsDetected:
      return "여러 개의 로그인이 감지되었습니다. 다시 로그인해주세요."
    }
  }
}