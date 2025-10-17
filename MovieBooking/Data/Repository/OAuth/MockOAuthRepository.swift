//
//  MockOAuthRepository.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Supabase
import AuthenticationServices

public class MockOAuthRepository: OAuthRepositoryProtocol {
  // MARK: - Handlers

  public var extractIdTokenHandler: (ASAuthorizationAppleIDCredential) throws -> String = { _ in
    "dummy.id.token"
  }

  public var signInWithAppleHandler: (String, String) async throws -> Supabase.Session = { _, _ in
    throw TestError.unset("signInWithAppleHandler not set. Inject a fake Session in your test.")
  }

  public var signInWithOAuthHandler: (Provider, [(name: String, value: String?)]) async throws -> Void = { _, _ in
    // no-op
  }

  public var updateDisplayNameHandler: (String) async throws -> Void = { _ in
    // no-op
  }

  public var getCurrentUserSessionHandler: () async throws -> UserEntity = {
    UserEntity()
  }

  public var getCurrentSessionHandler: () async throws -> Session = {
    throw TestError.unset("getCurrentSessionHandler not set. Inject a fake Session in your test.")
  }

  public var waitForValidSessionHandler: () async throws -> Session = {
    throw TestError.unset("waitForValidSessionHandler not set. Inject a fake Session in your test.")
  }

  public var getCurrentProviderHandler: () async throws -> String? = {
    nil
  }

  // MARK: - Call tracking

  public private(set) var extractIdTokenCallCount = 0
  public private(set) var signInWithAppleCallCount = 0
  public private(set) var signInWithOAuthCallCount = 0
  public private(set) var updateDisplayNameCallCount = 0
  public private(set) var getCurrentUserSessionCallCount = 0
  public private(set) var getCurrentSessionCallCount = 0
  public private(set) var waitForValidSessionCallCount = 0
  public private(set) var getCurrentProviderCallCount = 0

  public private(set) var lastExtractedCredential: ASAuthorizationAppleIDCredential?
  public private(set) var lastSignInParams: (idToken: String, nonce: String)?
  public private(set) var lastOAuthParams: (provider: Provider, queryParams: [(name: String, value: String?)])?
  public private(set) var lastUpdatedDisplayName: String?

  nonisolated public init() {}

  // MARK: - Implementation

  public func extractIdToken(
    from credential: ASAuthorizationAppleIDCredential
  ) throws -> String {
    extractIdTokenCallCount += 1
    lastExtractedCredential = credential
    return try extractIdTokenHandler(credential)
  }

  public func signInWithApple(
    idToken: String,
    nonce: String
  ) async throws -> Session {
    signInWithAppleCallCount += 1
    lastSignInParams = (idToken, nonce)
    return try await signInWithAppleHandler(idToken, nonce)
  }

  public func signInWithOAuth(
    provider: Provider,
    queryParams: [(name: String, value: String?)]
  ) async throws {
    signInWithOAuthCallCount += 1
    lastOAuthParams = (provider, queryParams)
    try await signInWithOAuthHandler(provider, queryParams)
  }

  public func updateDisplayName(
    _ name: String
  ) async throws {
    updateDisplayNameCallCount += 1
    lastUpdatedDisplayName = name
    try await updateDisplayNameHandler(name)
  }

  public func getCurrentUserSession() async throws -> UserEntity {
    getCurrentUserSessionCallCount += 1
    return try await getCurrentUserSessionHandler()
  }

  public func getCurrentSession() async throws -> Session {
    getCurrentSessionCallCount += 1
    return try await getCurrentSessionHandler()
  }

  public func waitForValidSession() async throws -> Session {
    waitForValidSessionCallCount += 1
    return try await waitForValidSessionHandler()
  }

  public func getCurrentProvider() async throws -> String? {
    getCurrentProviderCallCount += 1
    return try await getCurrentProviderHandler()
  }
}
