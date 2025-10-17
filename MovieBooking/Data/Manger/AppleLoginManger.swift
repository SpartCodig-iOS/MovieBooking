//
//  AppleLoginManger.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import CryptoKit
import AuthenticationServices

public protocol AppleAuthRequestPreparing {
  @discardableResult func prepare(_ request: ASAuthorizationAppleIDRequest) -> String
}

public struct AppleLoginManger: AppleAuthRequestPreparing {
  public static let shared = AppleLoginManger()
  

  public func prepare(_ request: ASAuthorizationAppleIDRequest) -> String {
    let nonce = randomNonceString()
    request.requestedScopes = [.email, .fullName]
    request.nonce = sha256(nonce)
    return nonce
  }

  public func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()

    return hashString
  }

  public func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
          )
        }
        return random
      }

      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }

    return result
  }
}
