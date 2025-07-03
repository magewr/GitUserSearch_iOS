import Foundation

public protocol UserDetailInteractor {
    func getUserDetail(username: String) async throws -> UserDetail
    func getUserRepositories(username: String) async throws -> [Repository]
}

public class DefaultUserDetailInteractor: UserDetailInteractor {
    private let dataProtocol: UserDetailDataProtocol
    
    public init(dataProtocol: UserDetailDataProtocol) {
        self.dataProtocol = dataProtocol
    }
    
    public func getUserDetail(username: String) async throws -> UserDetail {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "UserDetailError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Username cannot be empty"])
        }
        
        return try await dataProtocol.getUserDetail(username: username)
    }
    
    public func getUserRepositories(username: String) async throws -> [Repository] {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "UserDetailError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Username cannot be empty"])
        }
        
        return try await dataProtocol.getUserRepositories(username: username)
    }
} 