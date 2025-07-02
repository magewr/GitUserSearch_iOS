import Foundation
import Observation
import DomainLayer

@Observable
public class SearchUsersViewModel {
    // MARK: - State Properties
    public var searchText: String = ""
    public var users: [GitUser] = []
    public var favoriteUsers: [GitUser] = []
    public var isLoading: Bool = false
    public var errorMessage: String?
    public var currentSearchMode: SearchMode = .api
    public var sortType: SortType? = nil
    public var orderType: OrderType = .desc
    
    // MARK: - Pagination
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    private let perPage: Int = 30
    
    // MARK: - Debounce
    private var searchTask: Task<Void, Never>?
    private let debounceDelay: TimeInterval = 0.5
    
    // MARK: - Use Cases
    private let searchUserUseCase: SearchUserUseCase
    private let favoriteUserUseCase: FavoriteUserUseCase
    
    public init(
        searchUserUseCase: SearchUserUseCase,
        favoriteUserUseCase: FavoriteUserUseCase
    ) {
        self.searchUserUseCase = searchUserUseCase
        self.favoriteUserUseCase = favoriteUserUseCase
        
        Task {
            await loadFavoriteUsers()
        }
    }
    
    // MARK: - Actions
    @MainActor
    public func searchUsers() async {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            users = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        hasMorePages = true
        
        do {
            let result = try await performSearch()
            users = result.items
            hasMorePages = result.items.count == perPage
        } catch {
            errorMessage = error.localizedDescription
            users = []
        }
        
        isLoading = false
    }
    
    @MainActor
    public func onSearchTextChanged() {
        scheduleSearch()
    }
    
    @MainActor
    public func loadMoreUsers() async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        currentPage += 1
        
        do {
            let result = try await performSearch()
            users.append(contentsOf: result.items)
            hasMorePages = result.items.count == perPage
        } catch {
            errorMessage = error.localizedDescription
            currentPage -= 1
        }
        
        isLoading = false
    }
    
    @MainActor
    public func toggleFavorite(for user: GitUser) async {
        do {
            try await favoriteUserUseCase.toggleFavoriteUser(user)
            await loadFavoriteUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    public func switchSearchMode(to mode: SearchMode) async {
        currentSearchMode = mode
        await searchUsers()
    }
    
    public func isFavoriteUser(_ user: GitUser) -> Bool {
        return favoriteUsers.contains(where: { $0.id == user.id })
    }
    
    // MARK: - Private Methods
    @MainActor
    private func scheduleSearch() {
        // 기존 검색 작업 취소
        searchTask?.cancel()
        
        // 새로운 디바운스된 검색 작업 예약
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(Int(debounceDelay * 1000)))
            
            if !Task.isCancelled {
                await searchUsers()
            }
        }
    }
    
    @MainActor
    private func loadFavoriteUsers() async {
        do {
            favoriteUsers = try await favoriteUserUseCase.getFavoriteUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func performSearch() async throws -> SearchResult {
        switch currentSearchMode {
        case .api:
            let parameters = SearchParameters(
                query: searchText,
                sort: sortType,
                order: orderType,
                page: currentPage,
                perPage: perPage
            )
            return try await searchUserUseCase.searchUsers(parameters: parameters)
            
        case .favorites:
            return try await searchUserUseCase.searchFavoriteUsers(query: searchText)
        }
    }
}

// MARK: - Search Mode
public enum SearchMode: CaseIterable {
    case api
    case favorites
    
    public var title: String {
        switch self {
        case .api: return "GitHub 검색"
        case .favorites: return "즐겨찾기 검색"
        }
    }
} 