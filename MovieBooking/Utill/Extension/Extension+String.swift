//
//  Extension+String.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation

extension String {
  func decodedJWTClaims() -> [String: Any]? {
    let parts = self.split(separator: ".")
    guard parts.count == 3 else { return nil }
    var base64 = String(parts[1])
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")
    while base64.count % 4 != 0 { base64.append("=") }
    guard let data = Data(base64Encoded: base64) else { return nil }
    return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
  }

  /// 붙여넣기/오토필 대비: 공백/제로폭 제거 + 소문자
  var normalizedId: String {
    self.replacingOccurrences(of: "\u{00A0}", with: " ")
      .replacingOccurrences(of: "\u{200B}", with: "")
      .replacingOccurrences(of: "\u{200C}", with: "")
      .replacingOccurrences(of: "\u{200D}", with: "")
      .replacingOccurrences(of: "\u{FEFF}", with: "")
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .lowercased()
  }

  var looksLikeEmail: Bool {
    range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) != nil
  }
}
