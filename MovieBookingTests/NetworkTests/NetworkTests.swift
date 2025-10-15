//
//  NetworkTests.swift
//  MovieBookingTests
//
//  Created by 홍석현 on 10/14/25.
//

import Foundation
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
    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(.contentType(.json))
        return headers
    }
    
    var parameters: RequestParameter? {
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

    // MARK: - Error Cases

    @Test("404 에러 테스트 - 존재하지 않는 리소스")
    func notFoundErrorTest() async throws {
        do {
            // 존재하지 않는 사용자 조회
            let _: UserDTO = try await provider.request(
                UserAPI.user(id: 999999)
            )

            // 여기 도달하면 안됨
            Issue.record("404 에러가 발생해야 하는데 성공했습니다")
        } catch let error as NetworkError {
            // NetworkError.httpError 확인
            if case .httpError(let statusCode, let response, let data) = error {
                print("\n✅ 404 에러 정상 발생")
                print("  - StatusCode: \(statusCode)")
                print("  - Response 존재: \(response != nil)")
                print("  - Data 존재: \(data != nil)")
                print("  - Data 크기: \(data?.count ?? 0) bytes")

                // 검증
                #expect(statusCode == 404)
                #expect(response != nil, "HTTPURLResponse가 있어야 합니다")
                #expect(data != nil, "에러 응답 데이터가 있어야 합니다")
            } else {
                Issue.record("httpError가 아닌 다른 NetworkError 발생: \(error)")
            }
        } catch {
            Issue.record("NetworkError가 아닌 다른 에러 발생: \(error)")
        }
    }

    @Test("잘못된 URL 에러 테스트")
    func invalidURLErrorTest() async throws {
        // 잘못된 URL을 만들기 위한 커스텀 API
        enum InvalidAPI: TargetType {
            case invalidURL

            var baseURL: String { "ht!tp://invalid" }  // 프로토콜 자체가 잘못됨
            var path: String { "/test" }
            var method: HTTPMethod { .get }
            var headers: [String : String]? { nil }
            var parameters: ParameterEncoding? { nil }
        }

        do {
            let _: UserDTO = try await provider.request(InvalidAPI.invalidURL)
            Issue.record("URL 관련 에러가 발생해야 합니다")
        } catch let error as NetworkError {
            // invalidURL 또는 unknown (URLSession 에러) 둘 다 허용
            switch error {
            case .invalidURL:
                print("\n✅ invalidURL 에러 정상 발생")
                print("  - 에러 메시지: \(error.localizedDescription)")
                #expect(true)

            case .unknown(let underlyingError):
                // URLSession에서 발생하는 URL 에러도 허용
                print("\n✅ URL 관련 에러 발생 (unknown으로 wrapping)")
                print("  - 에러 메시지: \(error.localizedDescription)")
                print("  - 원본 에러: \(underlyingError)")
                #expect(true)

            default:
                Issue.record("예상치 못한 NetworkError: \(error)")
            }
        } catch {
            Issue.record("NetworkError가 아닌 다른 에러: \(error)")
        }
    }

    @Test("JSON 디코딩 에러 테스트")
    func decodingErrorTest() async throws {
        // 잘못된 타입으로 파싱 시도
        struct WrongDTO: Codable {
            let nonExistentField: String
            let anotherWrongField: Int
        }

        do {
            let _: WrongDTO = try await provider.request(
                UserAPI.user(id: 1)
            )
            Issue.record("디코딩 에러가 발생해야 합니다")
        } catch let error as NetworkError {
            if case .decodingError(let underlyingError) = error {
                print("\n✅ 디코딩 에러 정상 발생")
                print("  - 에러 메시지: \(error.localizedDescription)")
                print("  - 원본 에러: \(underlyingError)")
                #expect(true)
            } else {
                Issue.record("decodingError가 아닌 다른 에러: \(error)")
            }
        } catch {
            Issue.record("예상치 못한 에러: \(error)")
        }
    }

    @Test("응답 없는 요청 - 에러 케이스")
    func noResponseRequestErrorTest() async throws {
        do {
            // 존재하지 않는 리소스 삭제 시도
            try await provider.request(
                UserAPI.delete(id: 999999)
            )
            print("\n⚠️  JSONPlaceholder는 DELETE에서 404를 반환하지 않습니다")
            #expect(true)
        } catch let error as NetworkError {
            // 만약 404가 발생한다면
            if case .httpError(let statusCode, let response, let data) = error {
                print("\n✅ DELETE 요청에서 HTTP 에러 발생")
                print("  - StatusCode: \(statusCode)")
                print("  - Response 존재: \(response != nil)")
                print("  - Data 존재: \(data != nil)")

                #expect(statusCode >= 400)
                #expect(response != nil)
                #expect(data != nil)
            }
        }
    }

    @Test("에러 로깅 중복 확인 - 수동 검증")
    func errorLoggingDuplicationTest() async throws {
        print("\n🔍 에러 로깅 중복 테스트 시작")
        print("⚠️  콘솔에서 '🛰 NETWORK Response LOG'가 한 번만 출력되는지 확인하세요\n")

        do {
            let _: UserDTO = try await provider.request(
                UserAPI.user(id: 999999)
            )
            Issue.record("404 에러가 발생해야 합니다")
        } catch {
            print("\n✅ 에러 발생 완료 - 위 로그가 한 번만 출력되었는지 확인하세요")
            #expect(true)
        }
    }
}
