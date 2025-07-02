import Foundation
import DomainLayer

public class FavoriteUserRepository: FavoriteUserDataProtocol {
    private let localService: FavoriteUserLocalServiceProtocol
    
    public init(localService: FavoriteUserLocalServiceProtocol) {
        self.localService = localService
    }
    
    public func addFavoriteUser(_ user: GitUser) async throws {
        try await localService.addFavoriteUser(user)
    }
    
    public func removeFavoriteUser(_ user: GitUser) async throws {
        try await localService.removeFavoriteUser(user)
    }
    
    public func getFavoriteUsers() async throws -> [GitUser] {
        return try await localService.getFavoriteUsers()
    }
    
    public func isFavoriteUser(_ user: GitUser) async throws -> Bool {
        return try await localService.isFavoriteUser(user)
    }
} 