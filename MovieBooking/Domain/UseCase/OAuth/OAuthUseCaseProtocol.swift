//
//  AuthUseCaseProtocol.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import AuthenticationServices

/// UseCase 레벨: 비즈니스 로직 담당 (복합적인 플로우, 도메인 규칙)
public protocol OAuthUseCaseProtocol: Sendable {

  // MARK: - 인증 플로우

  /// Apple 로그인 전체 플로우 실행 (기존과 동일한 동작)
  /// - 토큰 추출 → 로그인 → 이름 업데이트 → 세션 반환
  func signInWithAppleOnce(
    credential: ASAuthorizationAppleIDCredential,
    nonce: String
  ) async throws -> UserEntity

  /// 소셜 로그인 전체 플로우 실행
  /// - 소셜 로그인 → 세션 대기 → 로깅 → 사용자 정보 반환
  func signInWithSocial(type: SocialType) async throws -> UserEntity

}
