//
//  Extension+Sessions.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Supabase
import Foundation

import Supabase
import Foundation

extension Session {
  func toDomain(loginId overrideLoginId: String? = nil) -> UserEntity {
    let user = self.user

    let providerRawValue = user.appMetadata["provider"]?.stringValue ?? "unknown"
    let provider = SocialType(rawValue: providerRawValue) ?? .none

    let displayName: String? = {
      if let value = user.userMetadata["display_name"]?.stringValue { return value }
      if let value = user.userMetadata["full_name"]?.stringValue { return value }
      if let value = user.userMetadata["name"]?.stringValue { return value }
      let familyName = user.userMetadata["family_name"]?.stringValue
      let givenName  = user.userMetadata["given_name"]?.stringValue
      let combined   = [familyName, givenName].compactMap { $0 }.joined()
      return combined.isEmpty ? nil : combined
    }()

    // 우선순위:
    // 1) 호출자가 넘긴 loginId
    // 2) user_metadata.login_id
    // 3) user_metadata.username
    // 4) 이메일이면 '@' 앞(local-part)
    let resolvedLoginId: String = {
      if let value = overrideLoginId, !value.isEmpty {
        return value
      }
      if let value = user.userMetadata["login_id"]?.stringValue, !value.isEmpty {
        return value
      }
      if let value = user.userMetadata["username"]?.stringValue, !value.isEmpty {
        return value
      }
      if let emailAddress = user.email,
         let atIndex = emailAddress.firstIndex(of: "@") {
        // 예: "test@test.com" → "test"
        return String(emailAddress[..<atIndex])
      }
      return ""
    }()

    return UserEntity(
      id: user.id.uuidString,
      userId: resolvedLoginId,
      email: user.email,
      displayName: displayName,
      provider: provider,
      tokens: AuthTokens(
        accessToken: self.accessToken,
        refreshToken: self.refreshToken
      )
    )
  }
}
