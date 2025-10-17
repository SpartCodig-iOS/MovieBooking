//
//  AuthRepository.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import AuthenticationServices
import Supabase
import LogMacro

public class AuthRepository: AuthRepositoryProtocol {
  private let client = SuperBaseManger.shared.client

  nonisolated public init() {}

  // MARK: - 인증 API

  public func signUp(
    email: String,
    password: String,
    userData: [String: AnyJSON]
  ) async throws {
    try await client.auth.signUp(
      email: email,
      password: password,
      data: userData
    )
  }

  public func signIn(
    email: String,
    password: String
  ) async throws {
    try await client.auth.signIn(
      email: email,
      password: password
    )
  }

  public func signOut() async throws {
    try await client.auth.signOut()
  }


  // MARK: - 데이터 조회

  public func getEmailByLoginId(_ loginId: String) async throws -> String {
    let resp = try await client
      .rpc("get_email_by_login_id", params: ["p_login_id": loginId])
      .execute()

    // RPC가 text를 반환하므로 Data -> String
    guard var email = String(data: resp.data, encoding: .utf8)?
      .trimmingCharacters(in: .whitespacesAndNewlines),
          !email.isEmpty else {
      throw AuthError.emailNotFound(loginId: loginId)
    }

    // text 반환이 따옴표 포함일 수 있어 처리
    if email.hasPrefix("\""), email.hasSuffix("\""), email.count >= 2 {
      email.removeFirst()
      email.removeLast()
    }
    return email.lowercased()
  }

  public func checkUserExists(userId: UUID) async throws -> Bool {
    let response = try await client
      .from("profiles")
      .select("id")
      .eq("id", value: userId.uuidString)
      .limit(1)
      .execute()
    return !response.data.isEmpty
  }

  public func getCurrentSocialType() async throws -> SocialType? {
    let session = try await client.auth.session
    let user = session.user
    let raw = user.appMetadata["provider"]?.stringValue ?? "unknown"
    return SocialType(rawValue: raw)
  }
}