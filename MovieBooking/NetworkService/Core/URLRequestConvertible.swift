//
//  URLRequestConvertible.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}
