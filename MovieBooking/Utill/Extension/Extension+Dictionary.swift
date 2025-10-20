//
//  Extension+Dictionary.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Supabase

extension Dictionary where Key == String, Value == AnyJSON {
  func string(forKey key: String) -> String? {
    guard let value = self[key] else { return nil }
    if case let .string(s) = value { return s }
    return nil
  }
}
