//
//  PrameterEncoding.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

enum ParameterEncoding {
    case query(Encodable)
    case body(Encodable)
}


extension Encodable {
    func toDictionary() throws -> [String: String] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NetworkError.encodingError(NSError(domain: "Encoding", code: -1))
        }
        
        // Any를 String으로 변환 (쿼리 파라미터용)
        return dictionary.compactMapValues { "\($0)" }
    }
}
