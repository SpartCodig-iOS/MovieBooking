//
//  HTTPHeaders.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

struct HTTPHeaders {
    private var headers: [String: String] = [:]
    
    init() {}
    
    init(_ dictionary: [String: String]) {
        self.headers = dictionary
    }
    
    mutating func add(_ header: HTTPHeader) {
        headers[header.name] = header.value
    }
    
    mutating func add(_ headers: [HTTPHeader]) {
        headers.forEach { add($0) }
    }
    
    // Dictionary로 변환
    var dictionary: [String: String] {
        return headers
    }
    
    // 서브스크립트 지원
    subscript(name: String) -> String? {
        get { headers[name] }
        set { headers[name] = newValue }
    }
}
