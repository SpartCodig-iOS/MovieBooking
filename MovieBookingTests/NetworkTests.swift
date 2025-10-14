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
    case search(name: String)
}

extension UserAPI: TargetType {
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .user(id: let id):
            return "/users/\(id)"
        case .search:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .user, .search:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: ParameterEncoding? {
        switch self {
        case .user:
            return nil
        case .search(let name):
            return .query(["username": name])
        }
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
    
    @Test("get http method 호출 테스트")
    func getUserTest() async throws {
        let user: UserDTO = try await provider.request(UserAPI.user(id: 1))
        print(user)
        #expect(user.id == 1)
    }
    
    @Test("쿼리 파라미터 인코딩 적합성 검사")
    func queryParameterEncodingTest() async throws {
        let users: [UserDTO] = try await provider.request(UserAPI.search(name: "Bret"))
        print(users)
        
        #expect(users.count > 0)
    }
}
