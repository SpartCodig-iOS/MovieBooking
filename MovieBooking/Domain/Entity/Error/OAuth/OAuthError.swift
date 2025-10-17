//
//  OAuthError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import AuthenticationServices

/// OAuth 도메인 전용 에러 (소셜 로그인)
public enum OAuthError: Error, Equatable {
  // MARK: - Apple 로그인 관련
  case appleSignInFailed(reason: String? = nil)
  case appleTokenExtractionFailed
  case appleCredentialInvalid
  case appleNonceMissing

  // MARK: - 소셜 로그인 관련
  case socialSignInFailed(provider: SocialType, reason: String? = nil)
  case unsupportedSocialProvider(String)
  case socialAuthenticationCancelled

  // MARK: - 프로바이더 관련
  case providerNotFound
  case invalidProviderConfiguration
  case providerTokenExpired(provider: SocialType)

  // MARK: - 사용자 정보 관련
  case displayNameUpdateFailed
  case socialTypeNotFound
  case userInfoExtractionFailed
}

// MARK: - 사용자 메시지 (UI friendly)
extension OAuthError: LocalizedError {
  public var errorDescription: String? {
    switch self {
      // MARK: - Apple 로그인 관련
    case .appleSignInFailed(let reason):
      if let reason = reason {
        return "Apple 로그인에 실패했습니다: \(reason)"
      }
      return "Apple 로그인에 실패했습니다. 다시 시도해주세요."

    case .appleTokenExtractionFailed:
      return "Apple 인증 정보를 가져올 수 없습니다."

    case .appleCredentialInvalid:
      return "Apple 로그인 자격 증명이 유효하지 않습니다."

    case .appleNonceMissing:
      return "Apple 로그인 보안 정보가 누락되었습니다."

      // MARK: - 소셜 로그인 관련
    case .socialSignInFailed(let provider, let reason):
      if let reason = reason {
        return "\(provider.description) 로그인에 실패했습니다: \(reason)"
      }
      return "\(provider.description) 로그인에 실패했습니다. 다시 시도해주세요."

    case .unsupportedSocialProvider(let provider):
      return "지원하지 않는 로그인 방식입니다: \(provider)"

    case .socialAuthenticationCancelled:
      return "소셜 로그인이 취소되었습니다."

      // MARK: - 프로바이더 관련
    case .providerNotFound:
      return "로그인 제공업체 정보를 찾을 수 없습니다."

    case .invalidProviderConfiguration:
      return "로그인 제공업체 설정이 올바르지 않습니다."

    case .providerTokenExpired(let provider):
      return "\(provider.description) 로그인이 만료되었습니다. 다시 로그인해주세요."

      // MARK: - 사용자 정보 관련
    case .displayNameUpdateFailed:
      return "사용자 이름 업데이트에 실패했습니다."

    case .socialTypeNotFound:
      return "소셜 로그인 타입을 확인할 수 없습니다."

    case .userInfoExtractionFailed:
      return "사용자 정보를 가져올 수 없습니다."
    }
  }
}