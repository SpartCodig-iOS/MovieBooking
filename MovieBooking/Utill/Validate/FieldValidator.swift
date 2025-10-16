//
//  FieldValidator.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import Foundation

enum FieldValidator {
  static func validateId(_ userId: String) -> String? {
    let trimmedUserId = userId.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedUserId.isEmpty { return "아이디를 입력해 주세요." }

    let pattern = "^[A-Za-z0-9_]{4,20}$"
    guard let regularExpression = try? NSRegularExpression(pattern: pattern) else {
      return "내부 오류가 발생했습니다."
    }
    let range = NSRange(location: 0, length: trimmedUserId.utf16.count)
    if regularExpression.firstMatch(in: trimmedUserId, range: range) == nil {
      return "아이디는 영문/숫자/밑줄 4~20자여야 합니다."
    }
    return nil
  }

  static func validatePassword(_ password: String) -> String? {
    if password.count < 8 { return "비밀번호는 8자 이상이어야 합니다." }

    let uppercaseLetters = CharacterSet.uppercaseLetters
    let lowercaseLetters = CharacterSet.lowercaseLetters
    let decimalDigitsSet = CharacterSet.decimalDigits
    let specialCharactersSet = CharacterSet.alphanumerics.inverted

    if password.rangeOfCharacter(from: uppercaseLetters) == nil { return "대문자를 최소 1자 포함하세요." }
    if password.rangeOfCharacter(from: lowercaseLetters) == nil { return "소문자를 최소 1자 포함하세요." }
    if password.rangeOfCharacter(from: decimalDigitsSet) == nil { return "숫자를 최소 1자 포함하세요." }
    if password.rangeOfCharacter(from: specialCharactersSet) == nil { return "특수문자를 최소 1자 포함하세요." }
    return nil
  }

  static func validateConfirm(_ password: String, _ confirmation: String) -> String? {
    if confirmation.isEmpty { return "비밀번호 확인을 입력해 주세요." }
    if password != confirmation { return "비밀번호가 일치하지 않습니다." }
    return nil
  }

  static func validateEmail(_ emailAddress: String) -> String? {
    let trimmedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedEmail.isEmpty { return "이메일을 입력해 주세요." }

    // 간단한 이메일 형식 검사 (필요시 더 엄격한 정규식으로 교체 가능)
    let pattern = #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#
    guard let regularExpression = try? NSRegularExpression(pattern: pattern) else {
      return "내부 오류가 발생했습니다."
    }
    let range = NSRange(location: 0, length: trimmedEmail.utf16.count)
    if regularExpression.firstMatch(in: trimmedEmail, range: range) == nil {
      return "올바른 이메일 형식이 아닙니다."
    }
    return nil
  }

  static func validateName(_ fullName: String) -> String? {
    let trimmedName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedName.isEmpty { return nil } // 선택 항목
    if trimmedName.count < 2 { return "이름은 2자 이상이어야 합니다." }
    if trimmedName.count > 30 { return "이름은 30자 이하여야 합니다." }
    return nil
  }
}
