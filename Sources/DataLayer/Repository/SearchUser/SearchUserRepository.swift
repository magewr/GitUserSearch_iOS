import Foundation
import DomainLayer

public class SearchUserRepository: SearchUserDataProtocol {
    private let apiService: GitHubAPIServiceProtocol
    
    public init(apiService: GitHubAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    public func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        return try await apiService.searchUsers(parameters: parameters)
    }
} 