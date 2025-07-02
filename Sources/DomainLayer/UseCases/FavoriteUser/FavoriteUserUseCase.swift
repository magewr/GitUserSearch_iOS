import Foundation

public protocol FavoriteUserUseCase {
    func addFavoriteUser(_ user: GitUser) async throws
    func removeFavoriteUser(_ user: GitUser) async throws
    func getFavoriteUsers() async throws -> [GitUser]
    func isFavoriteUser(_ user: GitUser) async throws -> Bool
    func toggleFavoriteUser(_ user: GitUser) async throws
}

public class DefaultFavoriteUserUseCase: FavoriteUserUseCase {
    private let favoriteUserInteractor: FavoriteUserInteractor
    
    public init(favoriteUserInteractor: FavoriteUserInteractor) {
        self.favoriteUserInteractor = favoriteUserInteractor
    }
    
    public func addFavoriteUser(_ user: GitUser) async throws {
        try await favoriteUserInteractor.addFavoriteUser(user)
    }
    
    public func removeFavoriteUser(_ user: GitUser) async throws {
        try await favoriteUserInteractor.removeFavoriteUser(user)
    }
    
    public func getFavoriteUsers() async throws -> [GitUser] {
        return try await favoriteUserInteractor.getFavoriteUsers()
    }
    
    public func isFavoriteUser(_ user: GitUser) async throws -> Bool {
        return try await favoriteUserInteractor.isFavoriteUser(user)
    }
    
    public func toggleFavoriteUser(_ user: GitUser) async throws {
        try await favoriteUserInteractor.toggleFavoriteUser(user)
    }
} 