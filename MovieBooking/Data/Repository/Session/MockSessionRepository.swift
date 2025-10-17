//
//  MockSessionRepository.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import Supabase

public class MockSessionRepository: SessionRepositoryProtocol {
  // MARK: - Handlers

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

  // MARK: - Call tracking

  public private(set) var getCurrentSessionCallCount = 0
  public private(set) var waitForValidSessionCallCount = 0
  public private(set) var refreshSessionCallCount = 0
  public private(set) var isTokenExpiringSoonCallCount = 0

  public private(set) var lastIsTokenExpiringSoonParams: (session: Session, threshold: TimeInterval)?

  nonisolated public init() {}

  // MARK: - Implementation

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
}