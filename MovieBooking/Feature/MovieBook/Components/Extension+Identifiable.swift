//
//  Extension+Identifiable.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import Foundation

extension String: Identifiable {
  public var id: String { self }
}

extension Int: Identifiable {
  public var id: Int { self }
}
