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
    
    func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) async throws -> T {
        // 1. URLRequest 만들기
        let request = try urlConvertible.asURLRequest()
        // 2. 네트워크 요청 실행
        let data = try await performRequest(request)
        // 3. JSON 파싱
        return try decode(data)
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
