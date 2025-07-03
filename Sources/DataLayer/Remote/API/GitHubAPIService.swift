import Foundation
import DomainLayer

public protocol GitHubAPIServiceProtocol {
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult
    func getUserDetail(username: String) async throws -> UserDetail
    func getUserRepositories(username: String) async throws -> [Repository]
}

public class GitHubAPIService: GitHubAPIServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    public func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        let endpoint = GitHubEndpoint.searchUsers(parameters: parameters)
        return try await networkClient.request(endpoint)
    }
    
    public func getUserDetail(username: String) async throws -> UserDetail {
        let endpoint = GitHubEndpoint.getUserDetail(username: username)
        return try await networkClient.request(endpoint)
    }
    
    public func getUserRepositories(username: String) async throws -> [Repository] {
        let endpoint = GitHubEndpoint.getUserRepositories(username: username)
        return try await networkClient.request(endpoint)
    }
} 