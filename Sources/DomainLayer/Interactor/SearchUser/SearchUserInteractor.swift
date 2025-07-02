import Foundation

public protocol SearchUserInteractor {
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult
}

public class DefaultSearchUserInteractor: SearchUserInteractor {
    private let dataProtocol: SearchUserDataProtocol
    
    public init(dataProtocol: SearchUserDataProtocol) {
        self.dataProtocol = dataProtocol
    }
    
    public func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        guard !parameters.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return SearchResult(totalCount: 0, incompleteResults: false, items: [])
        }
        
        return try await dataProtocol.searchUsers(parameters: parameters)
    }
} 