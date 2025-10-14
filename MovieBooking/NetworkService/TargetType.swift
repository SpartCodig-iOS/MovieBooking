//
//  TargetType.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: ParameterEncoding? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let urlString = baseURL + path
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        if case .query(let encodable) = parameters {
            do {
                let queryDict = try encodable.toDictionary()
                components.queryItems = queryDict.map { URLQueryItem(name: $0.key, value: $0.value) }
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if case .body(let encodable) = parameters {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(encodable)
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        
        return request
    }
}
