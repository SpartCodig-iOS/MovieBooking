//
//  NetworkLogger.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation

struct NetworkLog {
    let id: String
    var requestLog: String?
    var responseLog: String?
    var isComplete: Bool {
        responseLog != nil
    }
}

actor NetworkLogger {
    private var logBuffer: [String: NetworkLog] = [:]
    
    init() {}
    
    func addRequestLog(_ request: URLRequest, id: String) {
        var log = logBuffer[id] ?? NetworkLog(id: id)
        log.requestLog = buildRequestLog(request, id: id)
        logBuffer[id] = log
    }
    
    func addResponseLog(
        _ response: HTTPURLResponse,
        data: Data,
        duration: TimeInterval,
        id: String
    ) {
        var log = logBuffer[id] ?? NetworkLog(id: id)
        log.responseLog = buildResponseLog(response, data: data, duration: duration, id: id)
        logBuffer[id] = log
        
        if log.isComplete {
            printCompleteLog(log)
            logBuffer.removeValue(forKey: id)
        }
    }
    
    func addErrorLog(
        _ error: Error,
        duration: TimeInterval,
        id: String
    ) {
        var log = logBuffer[id] ?? NetworkLog(id: id)
        log.responseLog = buildErrorLog(error, duration: duration, id: id)
        logBuffer[id] = log
        
        if log.isComplete {
            printCompleteLog(log)
            logBuffer.removeValue(forKey: id)
        }
    }
    
    
    private func buildRequestLog(
        _ request: URLRequest,
        id: String
    ) -> String {
        var log = ""
        
        log += "🛰 NETWORK Request LOG [\(id)]\n"
        log += "----------------------------------------------------\n"
        log += "1️⃣ URL / Method / Headers\n"
        log += "URL: \(request.url?.absoluteString ?? "Unknown")\n"
        log += "Method: \(request.httpMethod ?? "Unknown")\n"
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            log += "Headers:\n"
            headers.forEach { key, value in
                log += "  - \(key): \(value)\n"
            }
        } else {
            log += "Headers: 없음\n"
        }
        
        log += "----------------------------------------------------\n"
        log += "2️⃣ Body\n"
        
        if let body = request.httpBody {
            // 🎯 전체 JSON 출력 (제한 없음!)
            if let jsonString = body.prettyPrintedJSON {
                log += jsonString + "\n"
            } else if let bodyString = String(data: body, encoding: .utf8) {
                log += bodyString + "\n"
            } else {
                log += "[\(body.count) bytes]\n"
            }
        } else {
            log += "보낸 Body가 없습니다.\n"
        }
        
        log += "----------------------------------------------------"
        
        return log
    }
    private func buildResponseLog(_ response: HTTPURLResponse, data: Data, duration: TimeInterval, id: String) -> String {
        let statusEmoji = getStatusEmoji(response.statusCode)
        var log = ""
        
        log += "🛰 NETWORK Response LOG [\(id)]\n"
        log += "----------------------------------------------------\n"
        log += "3️⃣ 서버 연결 성공\n"
        log += "StatusCode: \(statusEmoji) \(response.statusCode)\n"
        log += "Duration: \(String(format: "%.3f", duration))s\n"
        log += "----------------------------------------------------\n"
        log += "4️⃣ Data 확인하기\n"
        
        // 🎯 전체 JSON 출력 (제한 없음!)
        if let jsonString = data.prettyPrintedJSON {
            log += jsonString + "\n"
        } else if let bodyString = String(data: data, encoding: .utf8) {
            log += bodyString + "\n"
        } else {
            log += "[\(data.count) bytes]\n"
        }
        
        log += "----------------------------------------------------"
        
        return log
    }
    
    private func buildErrorLog(_ error: Error, duration: TimeInterval, id: String) -> String {
        var log = ""
        
        log += "🛰 NETWORK Response LOG [\(id)]\n"
        log += "----------------------------------------------------\n"
        log += "3️⃣ 서버 연결 실패\n"
        log += "Duration: \(String(format: "%.3f", duration))s\n"
        
        if let networkError = error as? NetworkError {
            switch networkError {
            case .httpError(let statusCode, _, _):
                log += "StatusCode: \(statusCode)\n"
            case .decodingError(let err):
                log += "Decoding Error: \(err.localizedDescription)\n"
            case .invalidURL:
                log += "Error: 잘못된 URL\n"
            case .invalidResponse:
                log += "Error: 올바르지 않은 응답\n"
            case .encodingError(let err):
                log += "Encoding Error: \(err.localizedDescription)\n"
            case .noData:
                log += "Error: 응답 데이터 없음\n"
            case .unknown(let err):
                log += "Error: \(err.localizedDescription)\n"
            }
        } else {
            log += "Error: \(error.localizedDescription)\n"
        }
        
        log += "----------------------------------------------------\n"
        log += "4️⃣ Data 확인하기\n"
        log += "❗에러가 발생하여 데이터가 없습니다.\n"
        log += "----------------------------------------------------"
        
        return log
    }
    
    private func printCompleteLog(_ log: NetworkLog) {
        print("\n" + String(repeating: "=", count: 60))
        if let requestLog = log.requestLog {
            print(requestLog)
        }

        if let responseLog = log.responseLog {
            print(responseLog)
        }
        print(String(repeating: "=", count: 60) + "\n")
    }
    
    private func getStatusEmoji(_ statusCode: Int) -> String {
        switch statusCode {
        case 200...299: return "✅"
        case 300...399: return "🔄"
        case 400...499: return "⚠️"
        case 500...599: return "🔴"
        default: return "❓"
        }
    }
}


extension Data {
    var prettyPrintedJSON: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
}
