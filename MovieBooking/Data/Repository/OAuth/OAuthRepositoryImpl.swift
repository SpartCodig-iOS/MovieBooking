//
//  OAuthRepositoryImpl.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Supabase
import AuthenticationServices
import LogMacro

public class OAuthRepositoryImpl: OAuthInterface {
  private let client = SuperBaseManger.shared.client

  nonisolated public init() {}

  // MARK: - superbase 애플 로그인 토큰 받아오기
  public func idToken(
    from credential: ASAuthorizationAppleIDCredential
  ) throws -> String {
    guard
      let data = credential.identityToken,
      let token = String(data: data, encoding: .utf8)
    else {
      throw DomainError.authenticationFailed
    }
    return token
  }

  // MARK: - superbase 애플 로그인 인증 관련 token
  public func signInWithApple(
    idToken: String,
    nonce: String
  ) async throws -> Supabase.Session {
    try await client.auth.signInWithIdToken(
      credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
    )
  }

  // MARK: - superbase 이름 업데이트
  public func updateDisplayName(
    _ name: String
  ) async throws {
    try await client.auth.update(
      user: UserAttributes(data: ["display_name": .string(name)])
    )
  }

  // MARK: - superbase session return
  public func currentSession() async throws -> UserEntity {
    let session = try await client.auth.session
    return session.toDomain()
  }

  // MARK: - superbase 애플 로그인
  public func signInWithAppleOnce(
    credential: ASAuthorizationAppleIDCredential,
    nonce: String
  ) async throws -> UserEntity {
    let appleIdToken = try idToken(from: credential)

    _ = try await signInWithApple(idToken: appleIdToken, nonce: nonce)

    if let full = credential.fullName {
      let display = [full.familyName, full.givenName]
        .compactMap { $0 }
        .joined()
      if !display.isEmpty {
        try await updateDisplayName(display)
      }
    }

    return try await currentSession()
  }

  // MARK: - superbase 애플 제외 소셜 회원가입
  public func signInWithSocial(
    type: SocialType
  ) async throws -> UserEntity {
    try await client.auth.signInWithOAuth(
      provider: type.supabaseProvider,
      queryParams: type.promptParams
    )

    let session: Session = try await waitForSignedInSession()
    let user = session.user
    #logDebug("✅ 소셜 로그인 완료 → \(user.email ?? "unknown") / \(user.appMetadata["provider"]?.stringValue ?? "")")

    return session.toDomain()
  }

  // MARK: - 로그인 소셜 타입 확인
  public func fetchCurrentSocialType() async throws -> SocialType? {
    let session  = try await client.auth.session
    let user = session.user
    let raw = user.appMetadata["provider"]?.stringValue ?? "unknown"
    return SocialType(rawValue: raw)
  }


}
