//
//  NetworkError.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/13/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL         // 유효하지 않은 URL
    case noData             // 응답 데이터가 없음
    case invalidResponse    // HTTPResponse가 아님
    case httpError(statusCode: Int) // HTTTP 에러 (400, 500 등)
    case decodingError      // JSON 파싱 에러
    case unknown(Error)     // 예상하지 못한 에러
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다"
        case .noData:
            return "응답 데이터가 없습니다"
        case .invalidResponse:
            return "올바르지 않은 응답입니다"
        case .httpError(let statusCode):
            return "HTTP 에러: \(statusCode)"
        case .decodingError:
            return "데이터 파싱에 실패했습니다"
        case .unknown(let error):
            return "알 수 없는 에러: \(error.localizedDescription)"
        }
    }
}

struct NetworkWithErrorHandling {
    func request(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(response.statusCode) else {
                throw NetworkError.httpError(statusCode: response.statusCode)
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    
}
