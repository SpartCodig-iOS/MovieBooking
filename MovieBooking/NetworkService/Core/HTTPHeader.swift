//
//  HTTPHeader.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

struct HTTPHeader {
    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension HTTPHeader {
    // Content-Type
    static func contentType(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Content-Type", value: value)
    }
    
    static func contentType(_ type: ContentType) -> HTTPHeader {
        HTTPHeader(name: "Content-Type", value: type.rawValue)
    }
    
    // Authorization
    static func authorization(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: value)
    }
    
    static func authorization(bearerToken: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: "Bearer \(bearerToken)")
    }
    
    // Accept
    static func accept(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept", value: value)
    }
    
    static func accept(_ type: ContentType) -> HTTPHeader {
        HTTPHeader(name: "Accept", value: type.rawValue)
    }
    
    // User-Agent
    static func userAgent(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "User-Agent", value: value)
    }
}
