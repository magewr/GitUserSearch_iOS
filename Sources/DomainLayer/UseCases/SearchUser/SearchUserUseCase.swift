import Foundation

public protocol SearchUserUseCase {
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult
    func searchFavoriteUsers(query: String) async throws -> SearchResult
}

public class DefaultSearchUserUseCase: SearchUserUseCase {
    private let searchUserInteractor: SearchUserInteractor
    private let favoriteUserInteractor: FavoriteUserInteractor
    
    public init(
        searchUserInteractor: SearchUserInteractor,
        favoriteUserInteractor: FavoriteUserInteractor
    ) {
        self.searchUserInteractor = searchUserInteractor
        self.favoriteUserInteractor = favoriteUserInteractor
    }
    
    public func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        return try await searchUserInteractor.searchUsers(parameters: parameters)
    }
    
    public func searchFavoriteUsers(query: String) async throws -> SearchResult {
        let favoriteUsers = try await favoriteUserInteractor.getFavoriteUsers()
        
        // 즐겨찾기 사용자 중에서 검색어로 필터링
        let filteredUsers = favoriteUsers.filter { user in
            if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return true // 검색어가 비어있으면 모든 즐겨찾기 사용자 반환
            }
            return user.login.localizedCaseInsensitiveContains(query)
        }
        
        return SearchResult(
            totalCount: filteredUsers.count,
            incompleteResults: false,
            items: filteredUsers
        )
    }
} 