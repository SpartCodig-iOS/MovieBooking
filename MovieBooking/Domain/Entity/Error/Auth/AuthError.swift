//
//  AuthError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation

/// Auth 도메인 전용 에러 (일반 로그인/회원가입)
public enum AuthError: Error, Equatable {
  // MARK: - 로그인 관련
  case loginFailed(reason: String? = nil)
  case invalidCredentials
  case emailNotFound(loginId: String)
  case passwordIncorrect

  // MARK: - 회원가입 관련
  case signUpFailed(reason: String? = nil)
  case emailAlreadyExists
  case passwordTooWeak
  case invalidEmailFormat

  // MARK: - 사용자 관련
  case userNotFound(userId: UUID)
  case userAlreadyExists

  // MARK: - 데이터베이스 관련
  case databaseOperationFailed
  case rpcCallFailed(function: String)
}

// MARK: - 사용자 메시지 (UI friendly)
extension AuthError: LocalizedError {
  public var errorDescription: String? {
    switch self {
      // MARK: - 로그인 관련
    case .loginFailed(let reason):
      if let reason = reason {
        return "로그인에 실패했습니다: \(reason)"
      }
      return "로그인에 실패했습니다. 아이디와 비밀번호를 확인해주세요."

    case .invalidCredentials:
      return "아이디 또는 비밀번호가 올바르지 않습니다."

    case .emailNotFound(let loginId):
      return "등록되지 않은 아이디입니다: \(loginId)"

    case .passwordIncorrect:
      return "비밀번호가 올바르지 않습니다."

      // MARK: - 회원가입 관련
    case .signUpFailed(let reason):
      if let reason = reason {
        return "회원가입에 실패했습니다: \(reason)"
      }
      return "회원가입에 실패했습니다. 다시 시도해주세요."

    case .emailAlreadyExists:
      return "이미 가입된 이메일입니다."

    case .passwordTooWeak:
      return "비밀번호는 8자 이상, 영문/숫자/특수문자를 포함해야 합니다."

    case .invalidEmailFormat:
      return "올바른 이메일 형식을 입력해주세요."

      // MARK: - 사용자 관련
    case .userNotFound(let userId):
      return "사용자 정보를 찾을 수 없습니다: \(userId)"

    case .userAlreadyExists:
      return "이미 존재하는 사용자입니다."

      // MARK: - 데이터베이스 관련
    case .databaseOperationFailed:
      return "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요."

    case .rpcCallFailed(let function):
      return "서버 요청 처리 중 오류가 발생했습니다: \(function)"
    }
  }
}