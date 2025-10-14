//
//  AuthTokens.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation


public struct AuthTokens: Equatable, Hashable {
  public let accessToken: String
  public let refreshToken: String?
  
  public init(
    accessToken: String,
    refreshToken: String?
  ) {
    self.accessToken = accessToken; self.refreshToken = refreshToken
  }
}
