//
//  ValidationError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation

/// 유효성 검사 관련 에러
public enum ValidationError: Error, Equatable {
  case validationFailed(fields: [String])
  case invalidInput(field: String, reason: String? = nil)
  case requiredFieldMissing(field: String)
  case invalidFormat(field: String, expectedFormat: String? = nil)
  case outOfRange(field: String, min: Any? = nil, max: Any? = nil)

  // Equatable 구현을 위해 Any 대신 String으로 처리
  public static func == (lhs: ValidationError, rhs: ValidationError) -> Bool {
    switch (lhs, rhs) {
    case (.validationFailed(let lFields), .validationFailed(let rFields)):
      return lFields == rFields
    case (.invalidInput(let lField, let lReason), .invalidInput(let rField, let rReason)):
      return lField == rField && lReason == rReason
    case (.requiredFieldMissing(let lField), .requiredFieldMissing(let rField)):
      return lField == rField
    case (.invalidFormat(let lField, let lFormat), .invalidFormat(let rField, let rFormat)):
      return lField == rField && lFormat == rFormat
    case (.outOfRange(let lField, _, _), .outOfRange(let rField, _, _)):
      return lField == rField // min, max는 비교에서 제외
    default:
      return false
    }
  }
}

// MARK: - 사용자 메시지 (UI friendly)
extension ValidationError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .validationFailed(let fields):
      if fields.isEmpty {
        return "입력값이 올바르지 않습니다."
      }
      return "\(fields.joined(separator: ", ")) 항목을 확인해주세요."

    case .invalidInput(let field, let reason):
      if let reason = reason {
        return "\(field): \(reason)"
      }
      return "\(field) 항목이 올바르지 않습니다."

    case .requiredFieldMissing(let field):
      return "\(field)은(는) 필수 입력 항목입니다."

    case .invalidFormat(let field, let expectedFormat):
      if let format = expectedFormat {
        return "\(field)의 형식이 올바르지 않습니다. (\(format) 형식으로 입력해주세요)"
      }
      return "\(field)의 형식이 올바르지 않습니다."

    case .outOfRange(let field, let min, let max):
      var message = "\(field)의 값이 범위를 벗어났습니다."
      if let min = min, let max = max {
        message += " (\(min) ~ \(max) 사이의 값을 입력해주세요)"
      } else if let min = min {
        message += " (\(min) 이상의 값을 입력해주세요)"
      } else if let max = max {
        message += " (\(max) 이하의 값을 입력해주세요)"
      }
      return message
    }
  }
}