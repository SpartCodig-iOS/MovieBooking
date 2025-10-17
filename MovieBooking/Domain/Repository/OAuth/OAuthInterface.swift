//
//  OAuthInterface.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import AuthenticationServices
import Supabase

public protocol OAuthInterface: Sendable {
  func idToken(from credential: ASAuthorizationAppleIDCredential) throws -> String
  func signInWithApple(idToken: String, nonce: String) async throws -> Session
  func updateDisplayName(_ name: String) async throws
  func currentSession() async throws -> UserEntity
  func signInWithAppleOnce(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws -> UserEntity
  func signInWithSocial(type: SocialType) async throws -> UserEntity
  func fetchCurrentSocialType() async throws -> SocialType?
}

extension OAuthInterface {
   func waitForSignedInSession(
    timeout: TimeInterval = 20,
    interval: TimeInterval = 0.3
  ) async throws -> Session {
    let deadline = Date().addingTimeInterval(timeout)
    let client = SuperBaseManger.shared.client

    while Date() < deadline {
      if let s = try? await client.auth.session {
        return s
      }
      try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
    }

    throw URLError(.timedOut)
  }
}
