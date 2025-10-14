//
//  TargetType.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}
