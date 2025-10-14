//
//  Provider.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

class NetworkProvider {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ target: TargetType) async throws -> T {
        // 1. URLRequest 만들기
        let request = try buildRequest(from: target)
        // 2. 네트워크 요청 실행
        let data = try await performRequest(request)
        // 3. JSON 파싱
        return try decode(data)
    }
    
    private func buildRequest(
        from target: TargetType
    ) throws -> URLRequest {
        let urlString = target.baseURL + target.path
        // 1. URL 기본 생성
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // 2. 쿼리 파라미터 처리
        if case .query(let params) = target.parameters {
            components.queryItems = params.map({ key, value in
                URLQueryItem(name: key, value: "\(value)")
            })
        }
        
        guard let url = components.url else { // 쿼리가 있다면 components.url에서 query가 들어간 url이 나옴 
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        
        target.headers?.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    private func performRequest(
        _ request: URLRequest
    ) async throws -> Data {
        do {
            let (data, response) = try await session.data(for: request)
            
            // Reponse 검증
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // 상태 코드 확인
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }
            
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
