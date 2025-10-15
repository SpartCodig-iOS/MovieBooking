//
//  MockAuthRepositoryImpl.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import AuthenticationServices
import Supabase

final public class MockAuthRepositoryImpl : AuthInterface {
  public var idTokenHandler: (ASAuthorizationAppleIDCredential) throws -> String = { _ in
    "dummy.id.token"
  }

  public var signInWithAppleHandler: (String, String) async throws -> Supabase.Session = { _, _ in
    throw TestError.unset("signInWithAppleHandler not set. Inject a fake Session in your test.")
  }

  public var updateDisplayNameHandler: (String) async throws -> Void = { _ in
      // no-op
    }


  public var currentSessionHandler: () async throws -> UserEntity = {
    UserEntity()
  }

  public var signInWithAppleOnceHandler: (ASAuthorizationAppleIDCredential, String) async throws -> UserEntity = { _, _ in
    UserEntity()
  }



  // MARK: - Call tracking
  public private(set) var idTokenCallCount = 0
  public private(set) var signInWithAppleCallCount = 0
  public private(set) var updateDisplayNameCallCount = 0
  public private(set) var currentSessionCallCount = 0
  public private(set) var signInWithAppleOnceCallCount = 0

  public private(set) var lastIdTokenCredential: ASAuthorizationAppleIDCredential?
  public private(set) var lastSignInParams: (idToken: String, nonce: String)?
  public private(set) var lastUpdatedDisplayName: String?
  public private(set) var lastOnceParams: (credential: ASAuthorizationAppleIDCredential, nonce: String)?


  nonisolated public init() {}


  public func idToken(
    from credential: ASAuthorizationAppleIDCredential
  ) throws -> String {
    idTokenCallCount += 1
    lastIdTokenCredential = credential
    return try idTokenHandler(credential)
  }

  public func signInWithApple(
    idToken: String,
    nonce: String
  ) async throws -> Auth.Session {
    signInWithAppleCallCount += 1
    lastSignInParams = (idToken, nonce)
    return try await signInWithAppleHandler(idToken, nonce)
  }

  public func updateDisplayName(
    _ name: String
  ) async throws {
    updateDisplayNameCallCount += 1
    lastUpdatedDisplayName = name
    try await updateDisplayNameHandler(name)
  }

  public func currentSession() async throws -> UserEntity {
    currentSessionCallCount += 1
    return try await currentSessionHandler()
  }

  public func signInWithAppleOnce(
    credential: ASAuthorizationAppleIDCredential,
    nonce: String
  ) async throws -> UserEntity {
    signInWithAppleOnceCallCount += 1
    lastOnceParams = (credential, nonce)
    return try await signInWithAppleOnceHandler(credential, nonce)
  }

  public func signInWithSocial(type: SocialType) async throws -> UserEntity {
    return UserEntity()
  }
}


// MARK: - TestError
public enum TestError: Error, CustomStringConvertible {
  case unset(String)
  public var description: String {
    switch self {
      case .unset(let msg): return msg
    }
  }
}
