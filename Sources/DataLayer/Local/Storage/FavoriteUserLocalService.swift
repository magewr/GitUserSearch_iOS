import Foundation
import DomainLayer

public protocol FavoriteUserLocalServiceProtocol {
    func addFavoriteUser(_ user: GitUser) async throws
    func removeFavoriteUser(_ user: GitUser) async throws
    func getFavoriteUsers() async throws -> [GitUser]
    func isFavoriteUser(_ user: GitUser) async throws -> Bool
}

public class FavoriteUserLocalService: FavoriteUserLocalServiceProtocol {
    private let storage: LocalStorageProtocol
    private let favoritesKey = "favorite_users"
    
    public init(storage: LocalStorageProtocol) {
        self.storage = storage
    }
    
    public func addFavoriteUser(_ user: GitUser) async throws {
        var favoriteUsers = try await getFavoriteUsers()
        
        // 이미 존재하는지 확인
        if !favoriteUsers.contains(where: { $0.id == user.id }) {
            favoriteUsers.append(user)
            try storage.save(favoriteUsers, forKey: favoritesKey)
        }
    }
    
    public func removeFavoriteUser(_ user: GitUser) async throws {
        var favoriteUsers = try await getFavoriteUsers()
        favoriteUsers.removeAll { $0.id == user.id }
        try storage.save(favoriteUsers, forKey: favoritesKey)
    }
    
    public func getFavoriteUsers() async throws -> [GitUser] {
        do {
            return try storage.load([GitUser].self, forKey: favoritesKey) ?? []
        } catch {
            throw StorageError.decodingFailed(error)
        }
    }
    
    public func isFavoriteUser(_ user: GitUser) async throws -> Bool {
        let favoriteUsers = try await getFavoriteUsers()
        return favoriteUsers.contains(where: { $0.id == user.id })
    }
} 