import Foundation

public protocol SearchUserDataProtocol {
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult
}

public protocol FavoriteUserDataProtocol {
    func addFavoriteUser(_ user: GitUser) async throws
    func removeFavoriteUser(_ user: GitUser) async throws
    func getFavoriteUsers() async throws -> [GitUser]
    func isFavoriteUser(_ user: GitUser) async throws -> Bool
} 