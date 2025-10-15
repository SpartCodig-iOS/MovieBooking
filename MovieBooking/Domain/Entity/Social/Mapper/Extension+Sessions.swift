//
//  Extension+Sessions.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Supabase
import Foundation

extension Session {
  func toDomain() -> UserEntity {
    let user = self.user

    let providerRaw = user.appMetadata["provider"]?.stringValue ?? "unknown"
    let provider = SocialType(rawValue: providerRaw) ?? .none

    let display: String? = {
      if let s = user.userMetadata["display_name"]?.stringValue { return s }
      if let s = user.userMetadata["full_name"]?.stringValue { return s }
      if let s = user.userMetadata["name"]?.stringValue { return s }
      let family = user.userMetadata["family_name"]?.stringValue
      let given  = user.userMetadata["given_name"]?.stringValue
      let joined = [family, given].compactMap { $0 }.joined()
      return joined.isEmpty ? nil : joined
    }()

    return .init(
      id: user.id.uuidString,
      email: user.email,
      displayName: display,
      provider: provider,
      tokens: .init(
        accessToken: self.accessToken,
        refreshToken: self.refreshToken
      )
    )
  }
}
