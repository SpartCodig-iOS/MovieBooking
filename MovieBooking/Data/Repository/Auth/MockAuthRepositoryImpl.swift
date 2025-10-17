//
//  MockAuthRepositoryImpl.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import AuthenticationServices
import Supabase

final public class MockAuthRepositoryImpl : AuthInterface {
  


  nonisolated public init() {}


  public func signUpNormalUser(name: String, email: String, password: String) async throws -> UserEntity {
    return UserEntity()
  }

  public func loginlUser(email: String, password: String) async throws -> UserEntity {
    return UserEntity()
  }

  public  func resolveEmail(fromLoginId loginId: String) async throws -> String  {
    return ""
  }

  public func checkSession() async throws -> UserEntity {
    return UserEntity()
  }

  public func checkUserExists(userId: UUID) async throws -> Bool {
    return false
  }

  public func isTokenExpiringSoon(
    _ session: Auth.Session,
    threshold: TimeInterval
  )  async throws  -> Bool {
    return false
  }

  public func sessionLogOut() async throws {
  }

  public func refreshSession() async throws -> UserEntity {
    return UserEntity()
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
