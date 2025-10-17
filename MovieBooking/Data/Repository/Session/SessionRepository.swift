//
//  SessionRepository.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import Supabase
import LogMacro

public class SessionRepository: SessionRepositoryProtocol {
  private let client = SuperBaseManger.shared.client

  nonisolated public init() {}

  // MARK: - 세션 관리 API

  public func getCurrentSession() async throws -> Session {
    if let session = client.auth.currentSession {
      return session
    }
    return try await client.auth.session
  }

  public func waitForValidSession() async throws -> Session {
    if let current = client.auth.currentSession {
      return current
    }

    // 새 이벤트 대기
    for await (event, session) in client.auth.authStateChanges {
      switch event {
      case .signedIn, .tokenRefreshed:
        if let session = session {
          #logDebug("✅ 세션 확보됨:", session)
          return session
        }
      default:
        continue
      }
    }

    throw SessionError.sessionWaitTimeout(timeout: 20)
  }

  public func refreshSession() async throws -> Session {
    try await client.auth.refreshSession()
  }

  // MARK: - 세션 검증

  public func isTokenExpiringSoon(
    _ session: Session,
    threshold: TimeInterval
  ) -> Bool {
    // expiresAt은 Double (UNIX timestamp)
    let expireDate = Date(
      timeIntervalSince1970: session.expiresAt
    )

    let remaining = expireDate.timeIntervalSinceNow
    #logDebug("만료일:", expireDate)
    #logDebug("남은 시간:", remaining, "초")

    return remaining <= threshold
  }
}