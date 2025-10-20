//
//  AuthUseCase.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import AuthenticationServices
import ComposableArchitecture
import Supabase
import WeaveDI
import LogMacro

public struct OAuthUseCase: OAuthUseCaseProtocol {
  private let repository: OAuthRepositoryProtocol
  private let sessionUseCase: SessionUseCaseProtocol

  nonisolated public init(
    repository: OAuthRepositoryProtocol,
    sessionUseCase: SessionUseCaseProtocol
  ) {
    self.repository = repository
    self.sessionUseCase = sessionUseCase
  }

  // MARK: - 인증 플로우

  public func signInWithAppleOnce(
    credential: ASAuthorizationAppleIDCredential,
    nonce: String
  ) async throws -> UserEntity {
    // 1. 토큰 추출
    let appleIdToken = try repository.extractIdToken(from: credential)

    // 2. Apple 로그인
    _ = try await repository.signInWithApple(idToken: appleIdToken, nonce: nonce)

    // 3. 비즈니스 규칙: 이름이 있으면 업데이트
    if let full = credential.fullName {
      let display = [full.familyName, full.givenName]
        .compactMap { $0 }
        .joined()
      if !display.isEmpty {
        try await repository.updateDisplayName(display)
      }
    }

    // 4. 최종 사용자 정보 반환
    return try await repository.getCurrentUserSession()
  }

  public func signInWithSocial(type: SocialType) async throws -> UserEntity {
    // 1. 소셜 OAuth 로그인 시작
    try await repository.signInWithOAuth(
      provider: type.supabaseProvider,
      queryParams: type.promptParams
    )

    // 2. 세션 대기 및 도메인 변환 (SessionUseCase로 위임)
    let userEntity = try await sessionUseCase.waitForValidSession()

    // 3. 로깅 (비즈니스 관심사)
    #logDebug("✅ 소셜 로그인 완료 → \(userEntity.email ?? "unknown")")

    // 4. 도메인 객체 반환
    return userEntity
  }

}

// MARK: - DI 설정

extension OAuthUseCase: DependencyKey {
  public static var liveValue: OAuthUseCaseProtocol = {
    let repository = UnifiedDI.resolve(OAuthRepositoryProtocol.self) ?? OAuthRepository()
    let sessionRepository = UnifiedDI.resolve(SessionRepositoryProtocol.self) ?? SessionRepository()
    let sessionUseCase = UnifiedDI.resolve(SessionUseCaseProtocol.self)
      ?? SessionUseCase(repository: sessionRepository)
    return OAuthUseCase(
      repository: repository,
      sessionUseCase: sessionUseCase
    )
  }()
}

@AutoSyncExtension
public extension DependencyValues {
  var oAuthUseCase: OAuthUseCaseProtocol {
    get { self[OAuthUseCase.self] }
    set { self[OAuthUseCase.self] = newValue }
  }
}

// MARK: - Module 등록

extension RegisterModule {
  var oAuthUseCaseModule: @Sendable () -> Module {
    makeUseCaseWithRepository(
      OAuthUseCaseProtocol.self,
      repositoryProtocol: OAuthRepositoryProtocol.self,
      repositoryFallback: MockOAuthRepository(),
      factory: { repo in
        let sessionUseCase = UnifiedDI.resolve(SessionUseCaseProtocol.self)
          ?? SessionUseCase(
            repository: UnifiedDI.resolve(SessionRepositoryProtocol.self)
              ?? SessionRepository()
          )
        return OAuthUseCase(
          repository: repo,
          sessionUseCase: sessionUseCase
        )
      }
    )
  }

  var oAuthRepositoryModule: @Sendable () -> Module {
    makeDependency(OAuthRepositoryProtocol.self) {
      OAuthRepository()
    }
  }
}
