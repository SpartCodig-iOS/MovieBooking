//
//  UserEntity.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation


public struct UserEntity: Equatable, Identifiable, Hashable {
  public static let shared = UserEntity()

  public let id: String
  public let email: String?
  public let displayName: String?
  public let provider: SocialType
  public let tokens: AuthTokens
  
  public init(
    id: String = "",
    email: String? = nil,
    displayName: String? = nil,
    provider: SocialType = .none,
    tokens: AuthTokens = AuthTokens(accessToken: "", refreshToken: "")
  ) {
    self.id = id; self.email = email; self.displayName = displayName; self.provider = provider; self.tokens = tokens
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(email)
    hasher.combine(displayName)
    hasher.combine(provider.rawValue)
    hasher.combine(tokens.accessToken)
  }
}
