//
//  AuthRepositoryProtocol.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import AuthenticationServices
import Supabase

/// Repository 레벨: 실제 구현 담당 (순수한 API 호출, 데이터 변환)
public protocol AuthRepositoryProtocol: Sendable {

  // MARK: - 인증 API

  /// Supabase 회원가입 API 호출
  func signUp(email: String, password: String, userData: [String: AnyJSON]) async throws

  /// Supabase 로그인 API 호출
  func signIn(email: String, password: String) async throws

  /// 로그아웃 API 호출
  func signOut() async throws


  // MARK: - 데이터 조회

  /// 로그인 ID로 이메일 조회 (RPC 호출)
  func getEmailByLoginId(_ loginId: String) async throws -> String

  /// 사용자 존재 여부 확인 (DB 조회)
  func checkUserExists(userId: UUID) async throws -> Bool

  /// 현재 소셜 타입 조회
  func getCurrentSocialType() async throws -> SocialType?
}