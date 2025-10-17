//
//  AuthInterface.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import AuthenticationServices
import Supabase

public protocol AuthInterface: Sendable {
  func signUpNormalUser(
    name: String,
    email: String,
    password: String
  ) async throws -> UserEntity
  func loginlUser(
    email: String,
    password: String
  ) async throws -> UserEntity
  func resolveEmail(fromLoginId loginId: String) async throws -> String
  func checkSession() async throws -> UserEntity
  func checkUserExists(userId: UUID) async throws -> Bool
  func isTokenExpiringSoon(_ session: Session, threshold: TimeInterval) async throws -> Bool
  func sessionLogOut() async throws
  func refreshSession() async throws -> UserEntity
}


