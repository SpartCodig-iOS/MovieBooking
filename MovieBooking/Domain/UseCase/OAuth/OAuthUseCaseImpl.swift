//
//  OAuthUseCaseImpl.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import AuthenticationServices
import ComposableArchitecture
import Supabase
import WeaveDI

public struct OAuthUseCaseImpl: OAuthInterface {
  private let repository: OAuthInterface

  nonisolated public init(repository: OAuthInterface) {
    self.repository = repository
  }

  public func idToken(
    from credential: ASAuthorizationAppleIDCredential
  ) throws -> String {
    return try repository.idToken(from: credential)
  }

  public func signInWithApple(
    idToken: String,
    nonce: String
  ) async throws -> Auth.Session {
   return try await repository.signInWithApple(idToken: idToken, nonce: nonce)
  }

  public func updateDisplayName(
    _ name: String
  ) async throws {
    return try await repository.updateDisplayName(name)
  }

  public func currentSession() async throws -> UserEntity {
    return try await repository.currentSession()
  }

  public func signInWithAppleOnce(
    credential: ASAuthorizationAppleIDCredential,
    nonce: String
  ) async throws -> UserEntity {
    return try await repository.signInWithAppleOnce(credential: credential, nonce: nonce)
  }

  public func signInWithSocial(
    type: SocialType
  ) async throws -> UserEntity {
    return try await repository.signInWithSocial(type: type)
  }

  public func fetchCurrentSocialType() async throws -> SocialType? {
    return try await repository.fetchCurrentSocialType()
  }
}



extension OAuthUseCaseImpl: DependencyKey {
  public static var liveValue: OAuthInterface = {
    let repository = UnifiedDI.register(OAuthInterface.self) {
      OAuthRepositoryImpl()
    }
    return OAuthUseCaseImpl(repository: repository)
  }()
}

@AutoSyncExtension
public extension DependencyValues {
  var oAuthUseCase: OAuthInterface {
    get { self[OAuthUseCaseImpl.self] }
    set { self[OAuthUseCaseImpl.self] = newValue }
  }
}


extension RegisterModule {
  var oAuthUseCaseModule: @Sendable () -> Module {
    makeUseCaseWithRepository(
      OAuthInterface.self,
      repositoryProtocol: OAuthInterface.self,
      repositoryFallback: MockOAuthRepositoryImpl(),
      factory: { repo in
        OAuthUseCaseImpl(repository: repo)
      }
    )
  }

  var oAuthRepositoryModule: @Sendable () -> Module {
    makeDependency(OAuthInterface.self) {
      OAuthRepositoryImpl()
    }
  }
}

