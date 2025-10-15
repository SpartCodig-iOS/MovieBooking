//
//  AuthRepositoryImpl.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import AuthenticationServices
import Supabase
import LogMacro

public class AuthRepositoryImpl: AuthInterface {

  
  private let client = SuperBaseManger.shared.client

  nonisolated public init() {}

  public func idToken(from credential: ASAuthorizationAppleIDCredential) throws -> String {
    guard
      let data = credential.identityToken,
      let token = String(data: data, encoding: .utf8)
    else {
      throw DomainError.authenticationFailed
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

  public func updateDisplayName(_ name: String) async throws {
    try await client.auth.update(
      user: UserAttributes(data: ["display_name": .string(name)])
    )
  }

  public func currentSession() async throws -> UserEntity {
    let session = try await client.auth.session
    return session.toDomain()
  }

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

  public func signInWithSocial(type: SocialType) async throws -> UserEntity {
    try await client.auth.signInWithOAuth(
      provider: type.supabaseProvider,
      queryParams: type.promptParams
    )

    let session: Session = try await waitForSignedInSession()
    let user = session.user
    #logDebug("✅ 소셜 로그인 완료 → \(user.email ?? "unknown") / \(user.appMetadata["provider"]?.stringValue ?? "")")

    return session.toDomain()
  }


  private func waitForSignedInSession(
    timeout: TimeInterval = 20,
    interval: TimeInterval = 0.3
  ) async throws -> Session {
    let deadline = Date().addingTimeInterval(timeout)

    while Date() < deadline {
      if let s = try? await client.auth.session {
        return s
      }
      try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
    }

    throw URLError(.timedOut)
  }


  public func fetchCurrentSocialType() async throws -> SocialType? {
    let session  = try await client.auth.session
    let user = session.user
    let raw = user.appMetadata["provider"]?.stringValue ?? "unknown"
    return SocialType(rawValue: raw)
  }


}
