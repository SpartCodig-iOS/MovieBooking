//
//  ContentView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/13/25.
//

import SwiftUI
import AuthenticationServices
import Supabase
import CryptoKit

struct ContentView: View {
  // ✅ "anon public" key 사용
  let client = SupabaseClient(
    supabaseURL: URL(string: "https://depahiavjicplpqpcbwd.supabase.co")!,
    supabaseKey: "sb_publishable_DnDwIbBsCHselcdXZrgt7A_OiIO7BAd"
  )

  @State private var currentNonce: String?

  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      Text("나만의 영화관, 지금 시작하세요 🎬")
        .font(.title3)
        .foregroundColor(.secondary)

      SignInWithAppleButton { request in
        // ✅ 1) 요청 시 nonce 설정
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.email, .fullName]
        request.nonce = sha256(nonce)
      } onCompletion: { result in
        // ✅ 2) 로그인 완료 후 Supabase 연동
        Task {
          do {
            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential,
                  let idTokenData = credential.identityToken,
                  let idToken = String(data: idTokenData, encoding: .utf8),
                  let nonce = currentNonce
            else {
              print("❌ Apple credential parsing failed")
              return
            }

            // Supabase 로그인
            let session = try await client.auth.signInWithIdToken(
              credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
            )
            print("✅ Apple login success:", session.user.email ?? "no email")

            // ✅ 3) fullName 제공 시 user_metadata.display_name 저장 (공백 없이 '성+이름' → "서원지")
            if let fullName = credential.fullName {
              let displayName = [fullName.familyName, fullName.givenName]
                .compactMap { $0 }
                .joined() // 공백 없이 결합
              if !displayName.isEmpty {
                try await client.auth.update(
                  user: UserAttributes(
                    data: ["display_name": .string(displayName)]
                  )
                )
                print("📝 Saved display_name:", displayName)
              }
            }

            // ✅ 4) 현재 세션/유저 정보 + JWT 토큰 확인
            let sessionNow = try await client.auth.session
            let user = sessionNow.user
            let displayName = jsonString(user.userMetadata, key: "display_name") ?? "없음"
            let provider = jsonString(user.appMetadata, key: "provider") ?? "apple"

            print("👤 Email:", user.email ?? "nil")
            print("📛 Display Name:", displayName)
            print("🔐 Provider:", provider)

            // ✅ 5) JWT / RefreshToken 출력
            let accessToken = sessionNow.accessToken
            let refreshToken = sessionNow.refreshToken
            print("🔑 accessToken (JWT):", accessToken)
            print("♻️ refreshToken:", refreshToken ?? "nil")

            // ✅ 6) (선택) JWT 클레임 디코딩해서 확인
//            if let claims = decodeJWT(accessToken) {
//              print("🧾 JWT claims:", claims)
//            }
          } catch {
//            dump(error)
          }
        }
      }
      .signInWithAppleButtonStyle(.black)
      .frame(height: 50)
      .cornerRadius(12)
      .padding(.horizontal, 24)

      Spacer()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}

// MARK: - Nonce 유틸
func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remaining = length

  while remaining > 0 {
    var random: UInt8 = 0
    let status = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
    if status != errSecSuccess { fatalError("Unable to generate nonce.") }
    if random < charset.count {
      result.append(charset[Int(random % UInt8(charset.count))])
      remaining -= 1
    }
  }
  return result
}

func sha256(_ input: String) -> String {
  let hashed = SHA256.hash(data: Data(input.utf8))
  return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

// MARK: - AnyJSON → String 헬퍼
func jsonString(_ dict: [String: AnyJSON]?, key: String) -> String? {
  guard let value = dict?[key] else { return nil }
  if case let .string(s) = value { return s }
  return nil
}

// MARK: - JWT 클레임 디코더 (보기용, 검증 아님)
func decodeJWT(_ jwt: String) -> [String: Any]? {
  let parts = jwt.split(separator: ".")
  guard parts.count == 3 else { return nil }
  var base64 = String(parts[1])
  base64 = base64.replacingOccurrences(of: "-", with: "+")
                   .replacingOccurrences(of: "_", with: "/")
  while base64.count % 4 != 0 { base64.append("=") }
  guard let data = Data(base64Encoded: base64) else { return nil }
  return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
}
