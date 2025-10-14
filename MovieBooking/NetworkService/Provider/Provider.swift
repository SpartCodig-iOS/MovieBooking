//
//  Provider.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

class NetworkProvider {
    private let session: URLSession
    private var eventMonitors: [NetworkEventMonitor]
    
    init(
        session: URLSession = .shared,
        eventMonitors: [NetworkEventMonitor] = [LoggerEventMonitor()]
    ) {
        self.session = session
        self.eventMonitors = eventMonitors
    }
    
    func request<T: Decodable>(
        _ urlConvertible: URLRequestConvertible
    ) async throws -> T {
        // 고유 Request ID 생성
        let requestID = UUID().uuidString.prefix(8).uppercased()
        
        // 1. URLRequest 만들기
        let request = try urlConvertible.asURLRequest()
        eventMonitors.forEach { monitor in
            Task.detached {
                await monitor.requestDidStart(request, id: requestID)
            }
        }
        
        // 2. 네트워크 요청 실행
        let data = try await performRequest(request, requestID)
        // 3. JSON 파싱
        return try decode(data)
    }
    
    // Response가 없는 request 메서드
    func request(
        _ urlConvertible: URLRequestConvertible
    ) async throws {
        // 고유 Request ID 생성
        let requestID = UUID().uuidString.prefix(8).uppercased()
        
        // 1. URLRequest 만들기
        let request = try urlConvertible.asURLRequest()
        eventMonitors.forEach { monitor in
            Task.detached {
                await monitor.requestDidStart(request, id: requestID)
            }
        }
        
        // 2. 네트워크 요청 실행
        try await performRequest(request, requestID)
        return
    }
    
    @discardableResult
    private func performRequest(
        _ request: URLRequest,
        _ requestID: String
    ) async throws -> Data {
        let startTime = Date()
        do {
            let (data, response) = try await session.data(for: request)
            let duration = Date().timeIntervalSince(startTime)
            // Reponse 검증
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // 상태 코드 확인
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(
                    statusCode: httpResponse.statusCode,
                    response: httpResponse,
                    data: data
                )
            }
            
            eventMonitors.forEach { monitor in
                Task.detached {
                    await monitor.requestDidFinish(
                        request,
                        response: httpResponse,
                        data: data,
                        error: nil,
                        duration: duration,
                        id: requestID
                    )
                }
            }
            
            return data
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            let networkError = error as? NetworkError ?? NetworkError.unknown(error)
            
            // httpError인 경우 response/data 추출
            var response: HTTPURLResponse?
            var responseData: Data?
            
            if case .httpError(_, let res, let data) = networkError {
                response = res
                responseData = data
            }
            
            eventMonitors.forEach { monitor in
                Task.detached {
                    await monitor.requestDidFinish(
                        request,
                        response: response,
                        data: responseData,
                        error: networkError,
                        duration: duration,
                        id: requestID
                    )
                }
            }
            throw networkError
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
