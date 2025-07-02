import Foundation
import XCTest
@testable import DomainLayer
@testable import DataLayer

// MARK: - Test Data
extension GitUser {
    static let mockUser = GitUser(
        id: 12345,
        login: "testuser",
        nodeId: "MDQ6VXNlcjEyMzQ1",
        avatarUrl: "https://avatars.githubusercontent.com/u/12345?v=4",
        gravatarId: "",
        url: "https://api.github.com/users/testuser",
        htmlUrl: "https://github.com/testuser",
        followersUrl: "https://api.github.com/users/testuser/followers",
        subscriptionsUrl: "https://api.github.com/users/testuser/subscriptions",
        organizationsUrl: "https://api.github.com/users/testuser/orgs",
        reposUrl: "https://api.github.com/users/testuser/repos",
        receivedEventsUrl: "https://api.github.com/users/testuser/received_events",
        type: "User",
        score: 1.0
    )
    
    static let mockUser2 = GitUser(
        id: 67890,
        login: "anotheruser",
        nodeId: "MDQ6VXNlcjY3ODkw",
        avatarUrl: "https://avatars.githubusercontent.com/u/67890?v=4",
        gravatarId: "",
        url: "https://api.github.com/users/anotheruser",
        htmlUrl: "https://github.com/anotheruser",
        followersUrl: "https://api.github.com/users/anotheruser/followers",
        subscriptionsUrl: "https://api.github.com/users/anotheruser/subscriptions",
        organizationsUrl: "https://api.github.com/users/anotheruser/orgs",
        reposUrl: "https://api.github.com/users/anotheruser/repos",
        receivedEventsUrl: "https://api.github.com/users/anotheruser/received_events",
        type: "User",
        score: 0.8
    )
}

extension SearchResult {
    static let mockResult = SearchResult(
        totalCount: 2,
        incompleteResults: false,
        items: [.mockUser, .mockUser2]
    )
}

extension SearchParameters {
    static let mockParameters = SearchParameters(
        query: "test",
        page: 1,
        perPage: 30
    )
}

// MARK: - Test Errors
enum MockError: Error, Equatable {
    case networkError
    case decodingError
    case notFound
    case timeout
}

// MARK: - Mock Objects

// Mock URL Session Protocol
public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData, let response = mockResponse else {
            throw MockError.networkError
        }
        
        return (data, response)
    }
    
    func reset() {
        mockData = nil
        mockResponse = nil
        mockError = nil
    }
}

// Mock Network Client
final class MockNetworkClient: NetworkClientProtocol {
    var mockResult: Result<Any, Error>?
    
    func request<T: Codable>(_ endpoint: Endpoint) async throws -> T {
        guard let result = mockResult else {
            throw MockError.networkError
        }
        
        switch result {
        case .success(let data):
            guard let typedData = data as? T else {
                throw MockError.decodingError
            }
            return typedData
        case .failure(let error):
            throw error
        }
    }
    
    func reset() {
        mockResult = nil
    }
}

// Mock Endpoint
struct MockEndpoint: Endpoint {
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]?
    
    static let validEndpoint = MockEndpoint(
        baseURL: "https://api.github.com",
        path: "/search/users",
        method: .GET,
        queryItems: [URLQueryItem(name: "q", value: "test")]
    )
}

// Mock GitHub API Service
final class MockGitHubAPIService: GitHubAPIServiceProtocol {
    var mockResult: Result<SearchResult, Error>?
    var searchCallCount = 0
    var lastSearchParameters: SearchParameters?
    
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        searchCallCount += 1
        lastSearchParameters = parameters
        
        guard let result = mockResult else {
            throw MockError.networkError
        }
        
        switch result {
        case .success(let searchResult):
            return searchResult
        case .failure(let error):
            throw error
        }
    }
    
    func reset() {
        mockResult = nil
        searchCallCount = 0
        lastSearchParameters = nil
    }
}

// Mock Local Storage
final class MockLocalStorage: LocalStorageProtocol {
    private var storage: [String: Data] = [:]
    
    func save<T: Codable>(_ object: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(object)
        storage[key] = data
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let data = storage[key] else { return nil }
        return try JSONDecoder().decode(type, from: data)
    }
    
    func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }
    
    func exists(forKey key: String) -> Bool {
        return storage[key] != nil
    }
    
    func reset() {
        storage.removeAll()
    }
}

// Mock Favorite User Local Service
final class MockFavoriteUserLocalService: FavoriteUserLocalServiceProtocol {
    var mockUsers: [GitUser] = []
    
    func addFavoriteUser(_ user: GitUser) async throws {
        if !mockUsers.contains(where: { $0.id == user.id }) {
            mockUsers.append(user)
        }
    }
    
    func removeFavoriteUser(_ user: GitUser) async throws {
        mockUsers.removeAll { $0.id == user.id }
    }
    
    func getFavoriteUsers() async throws -> [GitUser] {
        return mockUsers
    }
    
    func isFavoriteUser(_ user: GitUser) async throws -> Bool {
        return mockUsers.contains { $0.id == user.id }
    }
    
    func reset() {
        mockUsers.removeAll()
    }
}

// MARK: - Domain Layer Mocks

// Mock Search User Interactor
final class MockSearchUserInteractor: SearchUserInteractor {
    var mockResult: Result<SearchResult, Error>?
    
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        guard let result = mockResult else {
            throw MockError.networkError
        }
        
        switch result {
        case .success(let searchResult):
            return searchResult
        case .failure(let error):
            throw error
        }
    }
    
    func reset() {
        mockResult = nil
    }
}

// Mock Favorite User Interactor
final class MockFavoriteUserInteractor: FavoriteUserInteractor {
    var mockUsers: [GitUser] = []
    
    func addFavoriteUser(_ user: GitUser) async throws {
        if !mockUsers.contains(where: { $0.id == user.id }) {
            mockUsers.append(user)
        }
    }
    
    func removeFavoriteUser(_ user: GitUser) async throws {
        mockUsers.removeAll { $0.id == user.id }
    }
    
    func getFavoriteUsers() async throws -> [GitUser] {
        return mockUsers
    }
    
    func isFavoriteUser(_ user: GitUser) async throws -> Bool {
        return mockUsers.contains { $0.id == user.id }
    }
    
    func toggleFavoriteUser(_ user: GitUser) async throws {
        if mockUsers.contains(where: { $0.id == user.id }) {
            try await removeFavoriteUser(user)
        } else {
            try await addFavoriteUser(user)
        }
    }
    
    func reset() {
        mockUsers.removeAll()
    }
}

// MARK: - Use Case Mocks

// Mock Search User Use Case
final class MockSearchUserUseCase: SearchUserUseCase {
    var mockAPIResult: Result<SearchResult, Error>?
    var mockFavoriteResult: Result<SearchResult, Error>?
    
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        guard let result = mockAPIResult else {
            throw MockError.networkError
        }
        
        switch result {
        case .success(let searchResult):
            return searchResult
        case .failure(let error):
            throw error
        }
    }
    
    func searchFavoriteUsers(query: String) async throws -> SearchResult {
        guard let result = mockFavoriteResult else {
            throw MockError.networkError
        }
        
        switch result {
        case .success(let searchResult):
            return searchResult
        case .failure(let error):
            throw error
        }
    }
    
    func reset() {
        mockAPIResult = nil
        mockFavoriteResult = nil
    }
}

// Mock Favorite User Use Case
final class MockFavoriteUserUseCase: FavoriteUserUseCase {
    var mockUsers: [GitUser] = []
    
    func addFavoriteUser(_ user: GitUser) async throws {
        if !mockUsers.contains(where: { $0.id == user.id }) {
            mockUsers.append(user)
        }
    }
    
    func removeFavoriteUser(_ user: GitUser) async throws {
        mockUsers.removeAll { $0.id == user.id }
    }
    
    func getFavoriteUsers() async throws -> [GitUser] {
        return mockUsers
    }
    
    func isFavoriteUser(_ user: GitUser) async throws -> Bool {
        return mockUsers.contains { $0.id == user.id }
    }
    
    func toggleFavoriteUser(_ user: GitUser) async throws {
        if mockUsers.contains(where: { $0.id == user.id }) {
            try await removeFavoriteUser(user)
        } else {
            try await addFavoriteUser(user)
        }
    }
    
    func reset() {
        mockUsers.removeAll()
    }
}

// MARK: - Test Helpers
extension XCTestCase {
    /// 비동기 테스트를 위한 헬퍼 메서드
    func waitFor<T>(
        _ asyncOperation: @escaping () async throws -> T,
        timeout: TimeInterval = 1.0,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> T {
        return try await asyncOperation()
    }
    
    /// 에러가 발생하는지 확인하는 헬퍼 메서드
    func assertThrowsError<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected error to be thrown", file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
} 