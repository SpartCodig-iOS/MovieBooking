//
//  SessionRepositoryProtocol.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import Supabase
import LogMacro

/// Repository 레벨: Session 실제 구현 담당 (순수한 API 호출, 데이터 변환)
public protocol SessionRepositoryProtocol: Sendable {

  // MARK: - 세션 관리 API

  /// 현재 세션 조회 (캐시된 세션 우선)
  func getCurrentSession() async throws -> Session

  /// 유효한 세션 대기 (이벤트 기반)
  func waitForValidSession() async throws -> Session

  /// 세션 새로고침 API 호출
  func refreshSession() async throws -> Session

  // MARK: - 세션 검증

  /// 토큰 만료 임박 여부 확인
  func isTokenExpiringSoon(_ session: Session, threshold: TimeInterval) -> Bool
}