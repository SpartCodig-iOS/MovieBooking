//
//  MockAuthRepository.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import AuthenticationServices
import Supabase

public class MockAuthRepository: AuthRepositoryProtocol {
  // MARK: - Handlers

  public var signUpHandler: (String, String, [String: AnyJSON]) async throws -> Void = { _, _, _ in
    // no-op
  }

  public var signInHandler: (String, String) async throws -> Void = { _, _ in
    // no-op
  }

  public var signOutHandler: () async throws -> Void = {
    // no-op
  }

  public var getCurrentSessionHandler: () async throws -> Session = {
    throw TestError.unset("getCurrentSessionHandler not set. Inject a fake Session in your test.")
  }

  public var waitForValidSessionHandler: () async throws -> Session = {
    throw TestError.unset("waitForValidSessionHandler not set. Inject a fake Session in your test.")
  }

  public var refreshSessionHandler: () async throws -> Session = {
    throw TestError.unset("refreshSessionHandler not set. Inject a fake Session in your test.")
  }

  public var isTokenExpiringSoonHandler: (Session, TimeInterval) -> Bool = { _, _ in
    false
  }

  public var getEmailByLoginIdHandler: (String) async throws -> String = { _ in
    "test@example.com"
  }

  public var checkUserExistsHandler: (UUID) async throws -> Bool = { _ in
    false
  }

  public var getCurrentSocialTypeHandler: () async throws -> SocialType? = {
    nil
  }

  // MARK: - Call tracking

  public private(set) var signUpCallCount = 0
  public private(set) var signInCallCount = 0
  public private(set) var signOutCallCount = 0
  public private(set) var getCurrentSessionCallCount = 0
  public private(set) var waitForValidSessionCallCount = 0
  public private(set) var refreshSessionCallCount = 0
  public private(set) var isTokenExpiringSoonCallCount = 0
  public private(set) var getEmailByLoginIdCallCount = 0
  public private(set) var checkUserExistsCallCount = 0
  public private(set) var getCurrentSocialTypeCallCount = 0

  public private(set) var lastSignUpParams: (email: String, password: String, userData: [String: AnyJSON])?
  public private(set) var lastSignInParams: (email: String, password: String)?
  public private(set) var lastIsTokenExpiringSoonParams: (session: Session, threshold: TimeInterval)?
  public private(set) var lastGetEmailByLoginIdParam: String?
  public private(set) var lastCheckUserExistsParam: UUID?

  nonisolated public init() {}

  // MARK: - Implementation

  public func signUp(
    email: String,
    password: String,
    userData: [String: AnyJSON]
  ) async throws {
    signUpCallCount += 1
    lastSignUpParams = (email, password, userData)
    try await signUpHandler(email, password, userData)
  }

  public func signIn(
    email: String,
    password: String
  ) async throws {
    signInCallCount += 1
    lastSignInParams = (email, password)
    try await signInHandler(email, password)
  }

  public func signOut() async throws {
    signOutCallCount += 1
    try await signOutHandler()
  }

  public func getCurrentSession() async throws -> Session {
    getCurrentSessionCallCount += 1
    return try await getCurrentSessionHandler()
  }

  public func waitForValidSession() async throws -> Session {
    waitForValidSessionCallCount += 1
    return try await waitForValidSessionHandler()
  }

  public func refreshSession() async throws -> Session {
    refreshSessionCallCount += 1
    return try await refreshSessionHandler()
  }

  public func isTokenExpiringSoon(
    _ session: Session,
    threshold: TimeInterval
  ) -> Bool {
    isTokenExpiringSoonCallCount += 1
    lastIsTokenExpiringSoonParams = (session, threshold)
    return isTokenExpiringSoonHandler(session, threshold)
  }

  public func getEmailByLoginId(_ loginId: String) async throws -> String {
    getEmailByLoginIdCallCount += 1
    lastGetEmailByLoginIdParam = loginId
    return try await getEmailByLoginIdHandler(loginId)
  }

  public func checkUserExists(userId: UUID) async throws -> Bool {
    checkUserExistsCallCount += 1
    lastCheckUserExistsParam = userId
    return try await checkUserExistsHandler(userId)
  }

  public func getCurrentSocialType() async throws -> SocialType? {
    getCurrentSocialTypeCallCount += 1
    return try await getCurrentSocialTypeHandler()
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