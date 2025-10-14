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
}
