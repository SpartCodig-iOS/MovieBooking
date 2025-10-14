//
//  Extension+Sessions.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Supabase
import Foundation

extension UserEntity {
  static func from(session: Session) -> UserEntity {
    let user = session.user
    let providerRaw = (user.appMetadata["provider"]?.stringValue) ?? "unknown"
    let provider = SocialType(rawValue: providerRaw) ?? .none
    let display = user.userMetadata["display_name"]?.stringValue
    let tokens = AuthTokens(accessToken: session.accessToken, refreshToken: session.refreshToken)
    return .init(
      id: user.id.uuidString,
      email: user.email,
      displayName: display,
      provider: provider ?? .none,
      tokens: tokens
    )
  }
}
