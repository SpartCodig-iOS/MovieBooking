//
//  NetworkEventMonitor.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

protocol NetworkEventMonitor {
    func requestDidStart(
        _ request: URLRequest,
        id: String
    ) async
    
    func requestDidFinish(
        _ request: URLRequest,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?,
        duration: TimeInterval,
        id: String
    ) async
}

class LoggerEventMonitor: NetworkEventMonitor {
    private let logger: NetworkLogger
    
    // 🎯 Actor를 외부에서 주입받음
    init(logger: NetworkLogger = NetworkLogger()) {
        self.logger = logger
    }
    
    func requestDidStart(
        _ request: URLRequest,
        id: String
    ) async {
        await logger.addRequestLog(request, id: id)
    }
    
    func requestDidFinish(
        _ request: URLRequest,
        response: HTTPURLResponse?,
        data: Data?,
        error: (any Error)?,
        duration: TimeInterval,
        id: String
    ) async {
        if let error = error {
            await logger.addErrorLog(error, duration: duration, id: id)
        } else if let response = response, let data = data {
            await logger.addResponseLog(response, data: data, duration: duration, id: id)
        }
    }
}
