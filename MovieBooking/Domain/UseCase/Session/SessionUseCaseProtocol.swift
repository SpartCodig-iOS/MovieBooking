//
//  SessionUseCaseProtocol.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import Supabase

/// UseCase 레벨: Session 비즈니스 로직 담당 (복합적인 플로우, 도메인 규칙)
public protocol SessionUseCaseProtocol: Sendable {

  // MARK: - 세션 플로우

  /// 현재 세션 체크 플로우 (세션 조회 + 도메인 변환)
  func checkSession() async throws -> UserEntity

  /// 유효한 세션 대기 플로우 (세션 대기 + 도메인 변환)
  func waitForValidSession() async throws -> UserEntity

  /// 세션 새로고침 플로우 (새로고침 + 도메인 변환)
  func refreshSession() async throws -> UserEntity

  // MARK: - 세션 검증 플로우

  /// 세션 유효성 검증 (토큰 만료 확인 포함)
  func isSessionValid() async throws -> Bool

  /// 토큰 만료 임박 확인
  func isTokenExpiringSoon(_ session: Session, threshold: TimeInterval) -> Bool

  /// 세션 새로고침이 필요한지 확인하고 필요시 자동 갱신
  func refreshSessionIfNeeded() async throws -> UserEntity
}