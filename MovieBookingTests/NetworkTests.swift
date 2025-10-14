//
//  NetworkTests.swift
//  MovieBookingTests
//
//  Created by 홍석현 on 10/14/25.
//

import Testing
@testable import MovieBooking

enum UserAPI {
    case user(id: Int)
}

extension UserAPI: TargetType {
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .user(id: let id):
            return "/users/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .user:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

struct NetworkTests {
    struct UserDTO: Codable {
        let id: Int
        let name: String
        let email: String
        let username: String
    }
    
    let provider = NetworkProvider()
    
    @Test
    func example() async throws {
        let user: UserDTO = try await provider.request(UserAPI.user(id: 1))
        print(user)
        #expect(user.id == 1)
    }
}
