//
//  PrameterEncoding.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

enum ParameterEncoding {
    case query([String: Any])   // URL 쿼리(?key=value)
    case body([String: Any])    // POST Body(JSON)
}
