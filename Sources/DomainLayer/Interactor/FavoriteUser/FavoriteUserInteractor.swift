import Foundation

public protocol FavoriteUserInteractor {
    func addFavoriteUser(_ user: GitUser) async throws
    func removeFavoriteUser(_ user: GitUser) async throws
    func getFavoriteUsers() async throws -> [GitUser]
    func isFavoriteUser(_ user: GitUser) async throws -> Bool
    func toggleFavoriteUser(_ user: GitUser) async throws
}

public class DefaultFavoriteUserInteractor: FavoriteUserInteractor {
    private let dataProtocol: FavoriteUserDataProtocol
    
    public init(dataProtocol: FavoriteUserDataProtocol) {
        self.dataProtocol = dataProtocol
    }
    
    public func addFavoriteUser(_ user: GitUser) async throws {
        try await dataProtocol.addFavoriteUser(user)
    }
    
    public func removeFavoriteUser(_ user: GitUser) async throws {
        try await dataProtocol.removeFavoriteUser(user)
    }
    
    public func getFavoriteUsers() async throws -> [GitUser] {
        return try await dataProtocol.getFavoriteUsers()
    }
    
    public func isFavoriteUser(_ user: GitUser) async throws -> Bool {
        return try await dataProtocol.isFavoriteUser(user)
    }
    
    public func toggleFavoriteUser(_ user: GitUser) async throws {
        let isFavorite = try await isFavoriteUser(user)
        if isFavorite {
            try await removeFavoriteUser(user)
        } else {
            try await addFavoriteUser(user)
        }
    }
} 