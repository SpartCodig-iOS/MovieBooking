//
//  AuthUseCase.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import WeaveDI
import ComposableArchitecture
import AuthenticationServices
import LogMacro
import Supabase

public struct AuthUseCase: AuthUseCaseProtocol {
  private let repository: AuthRepositoryProtocol
  private let sessionUseCase: SessionUseCaseProtocol

  nonisolated public init(
    repository: AuthRepositoryProtocol,
    sessionUseCase: SessionUseCaseProtocol
  ) {
    self.repository = repository
    self.sessionUseCase = sessionUseCase
  }

  // MARK: - 인증 플로우

  public func signUpNormalUser(
    name: String,
    email: String,
    password: String
  ) async throws -> UserEntity {
    // 1. 회원가입 API 호출
    try await repository.signUp(
      email: email,
      password: password,
      userData: ["display_name": .string(name)]
    )

    // 2. 세션 대기 및 도메인 변환 (SessionUseCase로 위임)
    let userEntity = try await sessionUseCase.waitForValidSession()

    // 3. 로깅 (비즈니스 관심사)
    #logDebug("회원가입 완료 → \(userEntity.email ?? "unknown")")

    return userEntity
  }

  public func loginlUser(
    email: String,
    password: String
  ) async throws -> UserEntity {
    // 비즈니스 로직: 결과적으로 UserEntity.userId에 들어갈 값
    var overrideLoginId: String

    if email.contains("@") {
      // 1. 이메일로 로그인
      try await repository.signIn(
        email: email,
        password: password
      )

      // 비즈니스 규칙: '@' 앞부분을 userId로 사용
      if let at = email.firstIndex(of: "@") {
        overrideLoginId = String(email[..<at])
      } else {
        overrideLoginId = email
      }

    } else {
      // 2. 아이디로 들어온 경우: login_id -> email 매핑 후 로그인
      let loginId = email.normalizedId
      // 파라미터 이름과 겹치지 않도록 다른 이름 사용
      let resolvedEmail = try await repository.getEmailByLoginId(loginId)

      try await repository.signIn(
        email: resolvedEmail,
        password: password
      )
      // 비즈니스 규칙: 아이디 로그인 시에는 그 아이디를 userId로 사용
      overrideLoginId = loginId
    }

    // 3. 세션 대기 및 도메인 변환 (SessionUseCase로 위임)
    let session = try await sessionUseCase.waitForValidSession()

    // 4. 로깅 (비즈니스 관심사)
    #logDebug("일반 로그인 완료 → \(session.email ?? "unknown")")

    // 5. 비즈니스 규칙: userId 주입
    var userEntity = session
    userEntity.userId = overrideLoginId

    return userEntity
  }

  public func resolveEmail(fromLoginId loginId: String) async throws -> String {
    return try await repository.getEmailByLoginId(loginId)
  }

  // MARK: - 세션 관리

  public func checkUserExists(userId: UUID) async throws -> Bool {
    return try await repository.checkUserExists(userId: userId)
  }

  public func sessionLogOut() async throws {
    try await repository.signOut()
  }
}

// MARK: - DI 설정

extension AuthUseCase: DependencyKey {
  public static var liveValue: AuthUseCaseProtocol = {
    let repository = UnifiedDI.resolve(AuthRepositoryProtocol.self) ?? AuthRepository()
    let sessionRepository = UnifiedDI.resolve(SessionRepositoryProtocol.self) ?? SessionRepository()
    let sessionUseCase = UnifiedDI.resolve(SessionUseCaseProtocol.self)
      ?? SessionUseCase(repository: sessionRepository)
    return AuthUseCase(
      repository: repository,
      sessionUseCase: sessionUseCase
    )
  }()
}

@AutoSyncExtension
public extension DependencyValues {
  var authUseCase: AuthUseCaseProtocol {
    get { self[AuthUseCase.self] }
    set { self[AuthUseCase.self] = newValue }
  }
}

// MARK: - Module 등록

extension RegisterModule {
  var authUseCaseModule: @Sendable () -> Module {
    makeUseCaseWithRepository(
      AuthUseCaseProtocol.self,
      repositoryProtocol: AuthRepositoryProtocol.self,
      repositoryFallback: MockAuthRepository(),
      factory: { repo in
        let sessionUseCase = UnifiedDI.resolve(SessionUseCaseProtocol.self)
          ?? SessionUseCase(
            repository: UnifiedDI.resolve(SessionRepositoryProtocol.self)
              ?? SessionRepository()
          )
        return AuthUseCase(
          repository: repo,
          sessionUseCase: sessionUseCase
        )
      }
    )
  }

  var authRepositoryModule: @Sendable () -> Module {
    makeDependency(AuthRepositoryProtocol.self) {
      AuthRepository()
    }
  }

}
