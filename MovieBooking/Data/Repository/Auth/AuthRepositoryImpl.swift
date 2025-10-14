//
//  AuthRepositoryImpl.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import AuthenticationServices
import Supabase

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
    return UserEntity.from(session: session)
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
}
