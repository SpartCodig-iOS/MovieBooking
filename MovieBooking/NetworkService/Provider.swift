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
                let error = NetworkError.httpError(statusCode: httpResponse.statusCode)
                eventMonitors.forEach {  monitor in
                    Task.detached {
                        await monitor.requestDidFinish(
                            request,
                            response: httpResponse,
                            data: data,
                            error: error,
                            duration: duration,
                            id: requestID
                        )
                    }
                }
                throw error
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
        } catch let error as NetworkError {
            let duration = Date().timeIntervalSince(startTime)
            eventMonitors.forEach { monitor in
                Task.detached {
                    await monitor.requestDidFinish(request, response: nil, data: nil, error: error, duration: duration, id: String(requestID))
                }
            }
            throw error
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            let networkError = NetworkError.unknown(error)
            eventMonitors.forEach { monitor in
                Task.detached {
                    await monitor.requestDidFinish(request, response: nil, data: nil, error: networkError, duration: duration, id: String(requestID))
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
