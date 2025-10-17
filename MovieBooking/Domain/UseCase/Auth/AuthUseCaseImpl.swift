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

  public func resolveEmail(
    fromLoginId loginId: String
  ) async throws -> String {
    return try await repository.resolveEmail(fromLoginId: loginId)
  }

  public func checkSession() async throws -> UserEntity {
    return try await repository.checkSession()
  }

  public func checkUserExists(
    userId: UUID
  ) async throws -> Bool {
    return try await repository.checkUserExists(userId: userId)
  }

  public func isTokenExpiringSoon(
    _ session: Auth.Session,
    threshold: TimeInterval = 60
  ) async throws -> Bool {
    return try await repository.isTokenExpiringSoon(session, threshold: threshold)
  }

  public func sessionLogOut() async throws {
    return try await repository.sessionLogOut()
  }

  public func refreshSession() async throws -> UserEntity {
    return try await repository.refreshSession()
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
