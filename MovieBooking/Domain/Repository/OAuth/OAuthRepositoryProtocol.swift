//
//  OAuthRepositoryInterface.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import AuthenticationServices
import Supabase

/// Repository 레벨: 실제 구현 담당 (순수한 API 호출, 데이터 변환)
public protocol OAuthRepositoryProtocol: Sendable {

  // MARK: - 토큰 관련

  /// Apple ID credential에서 토큰 추출
  func extractIdToken(from credential: ASAuthorizationAppleIDCredential) throws -> String

  /// Apple 로그인 API 호출
  func signInWithApple(idToken: String, nonce: String) async throws -> Session

  /// 소셜 OAuth 로그인 API 호출
  func signInWithOAuth(provider: Provider, queryParams: [(name: String, value: String?)]) async throws

  // MARK: - 사용자 정보 관리

  /// 사용자 이름 업데이트
  func updateDisplayName(_ name: String) async throws

  /// 현재 세션 조회 (UserEntity 반환)
  func getCurrentUserSession() async throws -> UserEntity

  /// 현재 세션 조회 (Session 반환)
  func getCurrentSession() async throws -> Session


  // MARK: - 프로바이더 정보

  /// 현재 로그인 프로바이더 조회
  func getCurrentProvider() async throws -> String?
}

