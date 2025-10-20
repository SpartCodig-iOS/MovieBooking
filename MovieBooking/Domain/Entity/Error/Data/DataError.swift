//
//  DataError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation

/// 데이터 관련 에러
public enum DataError: Error, Equatable {
  case notFound(resource: String? = nil)
  case dataCorrupted
  case serializationFailed
  case decodingFailed
  case encodingFailed
}

// MARK: - 사용자 메시지 (UI friendly)
extension DataError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .notFound(let resource):
      if let resource = resource {
        return "\(resource)을(를) 찾을 수 없습니다."
      }
      return "요청한 데이터를 찾을 수 없습니다."

    case .dataCorrupted:
      return "데이터가 손상되었습니다. 다시 시도해주세요."

    case .serializationFailed:
      return "데이터 변환 중 오류가 발생했습니다."

    case .decodingFailed:
      return "데이터 처리 중 오류가 발생했습니다."

    case .encodingFailed:
      return "데이터 저장 중 오류가 발생했습니다."
    }
  }
}