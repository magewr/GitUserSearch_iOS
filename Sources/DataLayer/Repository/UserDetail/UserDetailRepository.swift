import Foundation
import DomainLayer

public class UserDetailRepository: UserDetailDataProtocol {
    private let apiService: GitHubAPIServiceProtocol
    
    public init(apiService: GitHubAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    public func getUserDetail(username: String) async throws -> UserDetail {
        return try await apiService.getUserDetail(username: username)
    }
    
    public func getUserRepositories(username: String) async throws -> [Repository] {
        return try await apiService.getUserRepositories(username: username)
    }
} 