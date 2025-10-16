//
//  AuthRepositoryImpl.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import AuthenticationServices
import Supabase
import LogMacro

public class AuthRepositoryImpl: AuthInterface {

  
  private let client = SuperBaseManger.shared.client

  nonisolated public init() {}

  // MARK: - superbase 애플 로그인 토큰 받아오기
  public func idToken(from credential: ASAuthorizationAppleIDCredential) throws -> String {
    guard
      let data = credential.identityToken,
      let token = String(data: data, encoding: .utf8)
    else {
      throw DomainError.authenticationFailed
    }
    return token
  }

  // MARK: - superbase 애플 로그인 인증 관련 token
  public func signInWithApple(
    idToken: String,
    nonce: String
  ) async throws -> Supabase.Session { 
    try await client.auth.signInWithIdToken(
      credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
    )
  }

  // MARK: - superbase 이름 업데이트
  public func updateDisplayName(_ name: String) async throws {
    try await client.auth.update(
      user: UserAttributes(data: ["display_name": .string(name)])
    )
  }

  // MARK: - superbase session return
  public func currentSession() async throws -> UserEntity {
    let session = try await client.auth.session
    return session.toDomain()
  }

  // MARK: - superbase 애플 로그인
  public func signInWithAppleOnce(
    credential: ASAuthorizationAppleIDCredential,
    nonce: String
  ) async throws -> UserEntity {
    let appleIdToken = try idToken(from: credential)

    _ = try await signInWithApple(idToken: appleIdToken, nonce: nonce)

    if let full = credential.fullName {
      let display = [full.familyName, full.givenName]
        .compactMap { $0 }
        .joined()
      if !display.isEmpty {
        try await updateDisplayName(display)
      }
    }

    return try await currentSession()
  }

  // MARK: - superbase 애플 제외 소셜 회원가입
  public func signInWithSocial(type: SocialType) async throws -> UserEntity {
    try await client.auth.signInWithOAuth(
      provider: type.supabaseProvider,
      queryParams: type.promptParams
    )

    let session: Session = try await waitForSignedInSession()
    let user = session.user
    #logDebug("✅ 소셜 로그인 완료 → \(user.email ?? "unknown") / \(user.appMetadata["provider"]?.stringValue ?? "")")

    return session.toDomain()
  }

  // MARK: - superbase 세션기다리기
  private func waitForSignedInSession(
    timeout: TimeInterval = 20,
    interval: TimeInterval = 0.3
  ) async throws -> Session {
    let deadline = Date().addingTimeInterval(timeout)

    while Date() < deadline {
      if let s = try? await client.auth.session {
        return s
      }
      try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
    }

    throw URLError(.timedOut)
  }

  // MARK: - 로그인 소셜 타입 확인
  public func fetchCurrentSocialType() async throws -> SocialType? {
    let session  = try await client.auth.session
    let user = session.user
    let raw = user.appMetadata["provider"]?.stringValue ?? "unknown"
    return SocialType(rawValue: raw)
  }

  public func signUpNormalUser(name: String, email: String, password: String) async throws -> UserEntity {
     try await supabase.auth.signUp(
      email: email,
      password: password,
      data: [
        "display_name": .string(name),
      ]
      )

      let session: Session = try await waitForSignedInSession()
      let user = session.user
      #logDebug("회원가임 완료 → \(user.email ?? "unknown") / \(user.appMetadata["provider"]?.stringValue ?? "")")

      return session.toDomain()
  }

  public func loginlUser(
    email: String,
    password: String
  ) async throws -> UserEntity {

    // 결과적으로 UserEntity.userId에 들어갈 값
    var overrideLoginId: String

    if email.contains("@") {
      // 이메일로 로그인
      try await client.auth.signIn(
        email: email,
        password: password
      )

      // '@' 앞부분을 userId로 사용
      if let at = email.firstIndex(of: "@") {
        overrideLoginId = String(email[..<at])
      } else {
        overrideLoginId = email
      }

    } else {
      // 아이디로 들어온 경우: login_id -> email 매핑 후 로그인
      let loginId = email.normalizedId

      // 파라미터 이름과 겹치지 않도록 다른 이름 사용
      let resolvedEmail = try await resolveEmail(fromLoginId: loginId)

      try await client.auth.signIn(
        email: resolvedEmail,
        password: password
      )

      // 아이디 로그인 시에는 그 아이디를 userId로 사용
      overrideLoginId = loginId
    }

    let session: Session = try await waitForSignedInSession()
    let user = session.user
    #logDebug("일반 로그인 완료 → \(user.email ?? "unknown") / \(user.appMetadata["provider"]?.stringValue ?? "")")

    // 여기서 userId 주입
    return session.toDomain(loginId: overrideLoginId)
  }

  public func resolveEmail(fromLoginId loginId: String) async throws -> String {
    let resp = try await client
      .rpc("get_email_by_login_id", params: ["p_login_id": loginId])
      .execute()

    // RPC가 text를 반환하므로 Data -> String
    guard var email = String(data: resp.data, encoding: .utf8)?
      .trimmingCharacters(in: .whitespacesAndNewlines),
          !email.isEmpty else {
      throw NSError(domain: "auth", code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "아이디를 찾을 수 없어요."])
    }
    // text 반환이 따옴표 포함일 수 있어 처리
    if email.hasPrefix("\""), email.hasSuffix("\""), email.count >= 2 {
      email.removeFirst(); email.removeLast()
    }
    return email.lowercased()
  }
}
