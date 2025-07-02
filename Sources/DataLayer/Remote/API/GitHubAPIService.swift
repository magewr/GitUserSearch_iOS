import Foundation
import DomainLayer

public protocol GitHubAPIServiceProtocol {
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult
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
} 