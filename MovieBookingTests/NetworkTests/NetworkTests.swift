//
//  NetworkTests.swift
//  MovieBookingTests
//
//  Created by 홍석현 on 10/14/25.
//

import Testing
@testable import MovieBooking


// 검색 쿼리 파라미터
struct SearchUserQuery: Encodable {
    let username: String
}

// 사용자 생성 Body
struct CreateUserBody: Encodable {
    let name: String
    let email: String
    let username: String?
}

enum UserAPI {
    case user(id: Int)
    case search(SearchUserQuery)
    case create(CreateUserBody)
    case update(id: Int, name: String)
    case delete(id: Int)
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
        case .delete(let id):
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
        case .delete:
            return .delete
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: ParameterEncoding? {
        switch self {
        case .user, .delete:
            return nil
        case .search(let request):
            return .query(request)
        case .create(let request):
            return .body(request)
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
        let user: UserDTO = try await provider.request(
            UserAPI.user(id: 1)
        )
        print(user)
        #expect(user.id == 1)
    }
    
    @Test("쿼리 파라미터 테스트")
    func queryParameterEncodingTest() async throws {
        let users: [UserDTO] = try await provider.request(
            UserAPI.search(
                SearchUserQuery(username: "Bret")
            )
        )
        print(users)
        
        #expect(users.count > 0)
    }
    
    @Test("POST + Body 요청 테스트")
    func postRequestTest() async throws {
        let newUser: CreateUserResponse = try await provider.request(
            UserAPI.create(
                CreateUserBody(name: "홍길동", email: "hong@example.com", username: nil)
            )
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
    
    @Test("Delete 요청 테스트")
    func deleteRequestTest() async throws {
        try await provider.request(
            UserAPI.delete(id: 1)
        )
        print("\n✅ 사용자 삭제")
        #expect(true)
    }
}
