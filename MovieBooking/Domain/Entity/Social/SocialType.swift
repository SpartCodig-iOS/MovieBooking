//
//  SocialType.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation

import SwiftUI
import Supabase

public enum SocialType: String, CaseIterable, Identifiable, Hashable {
  case none
  case apple
  case google
  case kakao

  public var id: String { rawValue }

  var title: String {
    switch self {
      case .none:
        return ""
      case .apple:
        return "Apple로 로그인"
      case .google:
        return "Google로 로그인"
      case .kakao:
        return "Kakao로 로그인"
    }
  }

  var image: String {
    switch self {
      case .apple:
        return "apple.logo"
      case .google:
        return "google"
      case .kakao:
        return "kakao"
      case .none:
        return ""
    }
  }


  var color: Color {
    switch self {
      case .apple: return .black
      case .google: return .white
      case .kakao: return .brightYellow
      case .none: return .white
    }
  }

  var textColor: Color {
    switch self {
      case .apple:  return .white
      case .google: return .primary
      case .kakao:  return .black
      case .none: return .white
    }
  }

  var hasBorder: Bool {
    self == .google
  }

  var supabaseProvider: Auth.Provider {
    switch self {
      case .kakao: return .kakao
      case .google: return .google
      case .apple: return .apple
      case .none: return .email
    }
  }

  var promptParams: [(name: String, value: String?)] {
    switch self {
      case .kakao:  return [("prompt", "login")]
      case .google: return [("prompt", "select_account")]
      case .apple, .none: return []
    }
  }
}
