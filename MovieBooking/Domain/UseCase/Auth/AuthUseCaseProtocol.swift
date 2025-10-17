//
//  AuthUseCaseProtocol.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import AuthenticationServices
import Supabase

/// UseCase 레벨: 비즈니스 로직 담당 (복합적인 플로우, 도메인 규칙)
public protocol AuthUseCaseProtocol: Sendable {

  // MARK: - 인증 플로우

  /// 일반 회원가입 전체 플로우 실행 (기존과 동일한 동작)
  /// - 회원가입 → 세션 대기 → 로깅 → 사용자 정보 반환
  func signUpNormalUser(
    name: String,
    email: String,
    password: String
  ) async throws -> UserEntity

  /// 일반 로그인 전체 플로우 실행 (기존과 동일한 동작)
  /// - 이메일/아이디 분기 → 로그인 → 세션 대기 → userId 설정 → 사용자 정보 반환
  func loginlUser(
    email: String,
    password: String
  ) async throws -> UserEntity

  /// 아이디를 이메일로 변환하는 플로우
  func resolveEmail(fromLoginId loginId: String) async throws -> String

  // MARK: - 세션 관리

  /// 현재 세션 체크 플로우
  func checkSession() async throws -> UserEntity

  /// 사용자 존재 여부 확인
  func checkUserExists(userId: UUID) async throws -> Bool

  /// 토큰 만료 임박 확인
  func isTokenExpiringSoon(_ session: Session, threshold: TimeInterval) -> Bool

  /// 세션 로그아웃
  func sessionLogOut() async throws

  /// 세션 새로고침 플로우
  func refreshSession() async throws -> UserEntity
}