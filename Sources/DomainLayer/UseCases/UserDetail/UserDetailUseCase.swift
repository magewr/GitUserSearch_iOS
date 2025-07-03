import Foundation

public protocol UserDetailUseCase {
    func getUserDetail(username: String) async throws -> UserDetail
    func getUserRepositories(username: String) async throws -> [Repository]
}

public class DefaultUserDetailUseCase: UserDetailUseCase {
    private let userDetailInteractor: UserDetailInteractor
    
    public init(userDetailInteractor: UserDetailInteractor) {
        self.userDetailInteractor = userDetailInteractor
    }
    
    public func getUserDetail(username: String) async throws -> UserDetail {
        return try await userDetailInteractor.getUserDetail(username: username)
    }
    
    public func getUserRepositories(username: String) async throws -> [Repository] {
        return try await userDetailInteractor.getUserRepositories(username: username)
    }
} 