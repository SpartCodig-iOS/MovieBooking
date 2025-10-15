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
  func idToken(from credential: ASAuthorizationAppleIDCredential) throws -> String
  func signInWithApple(idToken: String, nonce: String) async throws -> Session
  func updateDisplayName(_ name: String) async throws
  func currentSession() async throws -> UserEntity
  func signInWithAppleOnce(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws -> UserEntity
  func signInWithSocial(type: SocialType) async throws -> UserEntity
}
