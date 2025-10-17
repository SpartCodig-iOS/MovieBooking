//
//  OAuthRepository.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Supabase
import AuthenticationServices
import LogMacro

public class OAuthRepository: OAuthRepositoryProtocol {
  private let client = SuperBaseManger.shared.client

  nonisolated public init() {}

  // MARK: - 토큰 관련

  public func extractIdToken(
    from credential: ASAuthorizationAppleIDCredential
  ) throws -> String {
    guard
      let data = credential.identityToken,
      let token = String(data: data, encoding: .utf8)
    else {
      throw OAuthError.appleTokenExtractionFailed
    }
    return token
  }

  public func signInWithApple(
    idToken: String,
    nonce: String
  ) async throws -> Supabase.Session {
    try await client.auth.signInWithIdToken(
      credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
    )
  }

  public func signInWithOAuth(
    provider: Provider,
    queryParams: [(name: String, value: String?)]
  ) async throws {
    try await client.auth.signInWithOAuth(
      provider: provider,
      queryParams: queryParams
    )
  }

  // MARK: - 사용자 정보 관리

  public func updateDisplayName(
    _ name: String
  ) async throws {
    try await client.auth.update(
      user: UserAttributes(data: ["display_name": .string(name)])
    )
  }

  public func getCurrentUserSession() async throws -> UserEntity {
    let session = try await client.auth.session
    return session.toDomain()
  }

  public func getCurrentSession() async throws -> Session {
    try await client.auth.session
  }

  // MARK: - 프로바이더 정보

  public func getCurrentProvider() async throws -> String? {
    let session = try await client.auth.session
    let user = session.user
    return user.appMetadata["provider"]?.stringValue
  }
}
