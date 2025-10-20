//
//  SessionUseCase.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import WeaveDI
import ComposableArchitecture
import Supabase
import LogMacro

public struct SessionUseCase: SessionUseCaseProtocol {
  private let repository: SessionRepositoryProtocol

  nonisolated public init(repository: SessionRepositoryProtocol) {
    self.repository = repository
  }

  // MARK: - 세션 플로우

  public func checkSession() async throws -> UserEntity {
    let session = try await repository.getCurrentSession()
    return session.toDomain()
  }

  public func waitForValidSession() async throws -> UserEntity {
    let session = try await repository.waitForValidSession()
    return session.toDomain()
  }

  public func refreshSession() async throws -> UserEntity {
    let session = try await repository.refreshSession()
    return session.toDomain()
  }

  // MARK: - 세션 검증 플로우

  public func isSessionValid() async throws -> Bool {
    do {
      let session = try await repository.getCurrentSession()
      // 토큰이 만료 임박이 아니면 유효
      return !repository.isTokenExpiringSoon(session, threshold: 60)
    } catch {
      // 세션 조회 실패시 무효
      return false
    }
  }

  public func isTokenExpiringSoon(
    _ session: Session,
    threshold: TimeInterval = 60
  ) -> Bool {
    return repository.isTokenExpiringSoon(session, threshold: threshold)
  }

  public func refreshSessionIfNeeded() async throws -> UserEntity {
    let currentSession = try await repository.getCurrentSession()

    // 비즈니스 로직: 토큰이 만료 임박이면 자동 갱신
    if repository.isTokenExpiringSoon(currentSession, threshold: 60) {
      #logDebug("토큰 만료 임박, 자동 갱신 시작")
      return try await refreshSession()
    } else {
      // 갱신 불필요시 현재 세션 반환
      return currentSession.toDomain()
    }
  }
}

// MARK: - DI 설정

extension SessionUseCase: DependencyKey {
  public static var liveValue: SessionUseCaseProtocol = {
    let repository = UnifiedDI.resolve(SessionRepositoryProtocol.self)
      ?? UnifiedDI.register(SessionRepositoryProtocol.self) {
        SessionRepository()
      }

    return UnifiedDI.resolve(SessionUseCaseProtocol.self)
      ?? UnifiedDI.register(SessionUseCaseProtocol.self) {
        SessionUseCase(repository: repository)
      }
  }()
}

@AutoSyncExtension
public extension DependencyValues {
  var sessionUseCase: SessionUseCaseProtocol {
    get { self[SessionUseCase.self] }
    set { self[SessionUseCase.self] = newValue }
  }
}

// MARK: - Module 등록

extension RegisterModule {
  var sessionUseCaseModule: @Sendable () -> Module {
    makeUseCaseWithRepository(
      SessionUseCaseProtocol.self,
      repositoryProtocol: SessionRepositoryProtocol.self,
      repositoryFallback: MockSessionRepository(),
      factory: { repo in
        SessionUseCase(repository: repo)
      }
    )
  }

  var sessionRepositoryModule: @Sendable () -> Module {
    makeDependency(SessionRepositoryProtocol.self) {
      SessionRepository()
    }
  }
}
