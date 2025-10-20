//
//  UserEntity+Mock.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation

// MARK: - UserEntity Mock Data

extension UserEntity {

  // MARK: - 개별 Mock 데이터

  /// Apple 로그인 사용자 Mock
  public static let mockAppleUser = UserEntity(
    id: "550e8400-e29b-41d4-a716-446655440001",
    userId: "apple_user",
    email: "apple.user@icloud.com",
    displayName: "Apple 사용자",
    provider: .apple,
    tokens: AuthTokens(
      accessToken: "mock_apple_access_token_12345",
      refreshToken: "mock_apple_refresh_token_12345"
    )
  )

  /// Google 로그인 사용자 Mock
  public static let mockGoogleUser = UserEntity(
    id: "550e8400-e29b-41d4-a716-446655440002",
    userId: "google_user",
    email: "google.user@gmail.com",
    displayName: "구글 사용자",
    provider: .google,
    tokens: AuthTokens(
      accessToken: "mock_google_access_token_12345",
      refreshToken: "mock_google_refresh_token_12345"
    )
  )

  /// 이메일 로그인 사용자 Mock
  public static let mockEmailUser = UserEntity(
    id: "550e8400-e29b-41d4-a716-446655440003",
    userId: "test1",
    email: "test1@test.com",
    displayName: "테스터",
    provider: .email,
    tokens: AuthTokens(
      accessToken: "mock_email_access_token_12345",
      refreshToken: "mock_email_refresh_token_12345"
    )
  )

  /// Kakao 로그인 사용자 Mock
  public static let mockKakaoUser = UserEntity(
    id: "550e8400-e29b-41d4-a716-446655440004",
    userId: "kakao_user",
    email: "kakao.user@kakao.com",
    displayName: "카카오 사용자",
    provider: .kakao,
    tokens: AuthTokens(
      accessToken: "mock_kakao_access_token_12345",
      refreshToken: "mock_kakao_refresh_token_12345"
    )
  )

  /// 빈 사용자 Mock (초기값)
  public static let mockEmptyUser = UserEntity(
    id: "",
    userId: "",
    email: nil,
    displayName: nil,
    provider: .none,
    tokens: AuthTokens(accessToken: "", refreshToken: "")
  )

  // MARK: - 다양한 시나리오별 Mock 배열

  /// 모든 제공자별 사용자 Mock 배열
  public static let mockUsers: [UserEntity] = [
    mockAppleUser,
    mockGoogleUser,
    mockEmailUser,
    mockKakaoUser
  ]

  /// 소셜 로그인 사용자들만
  public static let mockSocialUsers: [UserEntity] = [
    mockAppleUser,
    mockGoogleUser,
    mockKakaoUser
  ]

  // MARK: - 동적 Mock 생성 함수

  /// 사용자 정의 Mock 생성
  public static func createMockUser(
    provider: SocialType,
    userId: String = "mock_user",
    email: String? = "mock@test.com",
    displayName: String? = "Mock User"
  ) -> UserEntity {
    return UserEntity(
      id: UUID().uuidString,
      userId: userId,
      email: email,
      displayName: displayName,
      provider: provider,
      tokens: AuthTokens(
        accessToken: "mock_\(provider.rawValue)_access_token",
        refreshToken: "mock_\(provider.rawValue)_refresh_token"
      )
    )
  }

  /// 랜덤 Mock 사용자 생성
  public static func createRandomMockUser() -> UserEntity {
    let providers = SocialType.allCases.filter { $0 != .none }
    let randomProvider = providers.randomElement() ?? .email
    let randomId = Int.random(in: 1000...9999)

    return createMockUser(
      provider: randomProvider,
      userId: "user_\(randomId)",
      email: "user\(randomId)@test.com",
      displayName: "테스트 사용자 \(randomId)"
    )
  }
}

// MARK: - 테스트용 편의 Mock

#if DEBUG
extension UserEntity {
  /// 요청하신 원본 Mock (동일한 형태)
  public static let mockOriginalRequest = UserEntity(
    id: UUID().uuidString,
    userId: "test1",
    email: "test1@test.com",
    displayName: "테스터",
    provider: .apple,
    tokens: AuthTokens(accessToken: "", refreshToken: "")
  )
}
#endif