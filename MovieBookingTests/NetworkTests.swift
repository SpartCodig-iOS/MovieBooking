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
    case create(name: String, email: String)
    case update(id: Int, name: String)
}

extension UserAPI: TargetType {
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .user(id: let id):
            return "/users/\(id)"
        case .search, .create:
            return "/users"
        case .update(let id, _):
            return "/users/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .user, .search:
            return .get
        case .create:
            return .post
        case .update:
            return .put
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
        case .create(let name, let email):
            return .body([
                "name": name,
                "email": email
            ])
        case .update(_, let name):
            return .body(["name": name])
        }
    }
}

struct NetworkTests {
    struct UserDTO: Codable {
        let id: Int
        let name: String
        let email: String?
        let username: String?
    }
    
    struct CreateUserResponse: Codable {
        let id: Int
        let name: String
        let email: String
    }
    
    let provider = NetworkProvider()
    
    @Test("GET 요청 테스트")
    func getUserTest() async throws {
        let user: UserDTO = try await provider.request(UserAPI.user(id: 1))
        print(user)
        #expect(user.id == 1)
    }
    
    @Test("쿼리 파라미터 테스트")
    func queryParameterEncodingTest() async throws {
        let users: [UserDTO] = try await provider.request(UserAPI.search(name: "Bret"))
        print(users)
        
        #expect(users.count > 0)
    }
    
    @Test("POST + Body 요청 테스트")
    func postRequestTest() async throws {
        let newUser: CreateUserResponse = try await provider.request(
            UserAPI.create(name: "홍길동", email: "hong@example.com")
        )
        print(newUser)
        #expect(newUser.name == "홍길동")
    }
    
    @Test("PUT 요청 테스트")
    func putRequestTest() async throws {
        let updatedUser: UserDTO = try await provider.request(
            UserAPI.update(id: 1, name: "김철수")
        )
        print("\n✅ 사용자 업데이트: \(updatedUser)")
        #expect(updatedUser.name == "김철수")
    }
}
