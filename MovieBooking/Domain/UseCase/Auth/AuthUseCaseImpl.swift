//
//  AuthUseCaseImpl.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import WeaveDI
import ComposableArchitecture
import AuthenticationServices
import Supabase

public struct AuthUseCaseImpl: AuthInterface {
  private let repository: AuthInterface

  nonisolated public init(repository: AuthInterface) {
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

  public func signInWithSocial(type: SocialType) async throws -> UserEntity {
    return try await repository.signInWithSocial(type: type)
  }

  public func fetchCurrentSocialType() async throws -> SocialType? {
    return try await repository.fetchCurrentSocialType()
  }

  public func signUpNormalUser(
    name: String,
    email: String,
    password: String
  ) async throws -> UserEntity {
    return try await repository.signUpNormalUser(
      name: name,
      email: email,
      password: password
    )
  }

  public func loginlUser(
    email: String,
    password: String
  ) async throws -> UserEntity {
    return try await repository.loginlUser(
      email: email,
      password: password
    )
  }

  public func resolveEmail(fromLoginId loginId: String) async throws -> String {
    return try await repository.resolveEmail(fromLoginId: loginId)
  }
}


extension AuthUseCaseImpl: DependencyKey {
  public static var liveValue: AuthInterface = {
    let repository = UnifiedDI.register(AuthInterface.self) {
      AuthRepositoryImpl()
    }
    return AuthUseCaseImpl(repository: repository)
  }()
}

@AutoSyncExtension
public extension DependencyValues {
  var authUseCase: AuthInterface {
    get { self[AuthUseCaseImpl.self] }
    set { self[AuthUseCaseImpl.self] = newValue }
  }
}


extension RegisterModule {
  var authUseCaseModule: @Sendable () -> Module {
    makeUseCaseWithRepository(
      AuthInterface.self,
      repositoryProtocol: AuthInterface.self,
      repositoryFallback: MockAuthRepositoryImpl(),
      factory: { repo in
        AuthUseCaseImpl(repository: repo)
      }
    )
  }

  var authRepositoryModule: @Sendable () -> Module {
    makeDependency(AuthInterface.self) {
      AuthRepositoryImpl()
    }
  }
}
