//
//  SystemError.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation

/// 시스템 관련 에러
public enum SystemError: Error, Equatable {
  case dependencyUnavailable(service: String? = nil)
  case configurationError
  case insufficientPermissions(permission: String? = nil)
  case resourceExhausted(resource: String? = nil)
  case serviceUnavailable(service: String? = nil)
}

// MARK: - 사용자 메시지 (UI friendly)
extension SystemError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .dependencyUnavailable(let service):
      if let service = service {
        return "\(service) 서비스를 사용할 수 없습니다. 잠시 후 다시 시도해주세요."
      }
      return "서비스를 사용할 수 없습니다. 잠시 후 다시 시도해주세요."

    case .configurationError:
      return "앱 설정에 문제가 있습니다. 앱을 재시작해주세요."

    case .insufficientPermissions(let permission):
      if let permission = permission {
        return "\(permission) 권한이 필요합니다. 설정에서 권한을 허용해주세요."
      }
      return "권한이 필요합니다. 설정에서 권한을 허용해주세요."

    case .resourceExhausted(let resource):
      if let resource = resource {
        return "\(resource) 리소스가 부족합니다. 잠시 후 다시 시도해주세요."
      }
      return "시스템 리소스가 부족합니다. 잠시 후 다시 시도해주세요."

    case .serviceUnavailable(let service):
      if let service = service {
        return "\(service) 서비스가 일시적으로 사용할 수 없습니다."
      }
      return "서비스가 일시적으로 사용할 수 없습니다."
    }
  }
}