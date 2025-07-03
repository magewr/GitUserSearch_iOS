import SwiftUI
import DomainLayer
import DataLayer

public struct SearchUsersView: View {
    let viewModel: SearchUsersViewModel
    @FocusState private var isSearchFieldFocused: Bool
    
    public init(viewModel: SearchUsersViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // 검색 바
                searchBar
                
                // 필터 옵션
                SearchFilterView(
                    currentSearchMode: Binding(
                        get: { viewModel.currentSearchMode },
                        set: { newValue in
                            Task {
                                await viewModel.switchSearchMode(to: newValue)
                            }
                        }
                    ),
                    sortType: Binding(
                        get: { viewModel.sortType },
                        set: { viewModel.sortType = $0 }
                    ),
                    orderType: Binding(
                        get: { viewModel.orderType },
                        set: { viewModel.orderType = $0 }
                    ),
                    onSearchModeChange: { mode in
                        await viewModel.switchSearchMode(to: mode)
                    }
                )
                .padding(.vertical, 8)
                
                Divider()
                
                // 검색 결과 - 남은 모든 공간을 차지
                searchResultsView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Git User Search")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
            .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("확인") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("사용자 이름을 입력하세요", text: Binding(
                    get: { viewModel.searchText },
                    set: { viewModel.searchText = $0 }
                ))
                    .focused($isSearchFieldFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: viewModel.searchText) { _, _ in
                        viewModel.onSearchTextChanged()
                    }
                    .onSubmit {
                        Task {
                            await viewModel.searchUsers()
                        }
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                        viewModel.users = []
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if isSearchFieldFocused {
                Button("취소") {
                    isSearchFieldFocused = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Search Results
    private var searchResultsView: some View {
        ZStack {
            if viewModel.users.isEmpty && !viewModel.isLoading {
                emptyStateView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                userListView
            }
            
            if viewModel.isLoading && viewModel.users.isEmpty {
                loadingView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private var userListView: some View {
        List {
            ForEach(viewModel.users, id: \.id) { user in
                ZStack {
                    NavigationLink(destination: UserDetailView(
                        username: user.login,
                        userDetailUseCase: DIContainer.shared.userDetailUseCase
                    )) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    UserRowView(
                        user: user,
                        isFavorite: viewModel.isFavoriteUser(user),
                        onFavoriteToggle: {
                            Task {
                                await viewModel.toggleFavorite(for: user)
                            }
                        }
                    )
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                .onAppear {
                    // 무한 스크롤
                    if user.id == viewModel.users.last?.id {
                        Task {
                            await viewModel.loadMoreUsers()
                        }
                    }
                }
            }
            
            // 더 로딩 중일 때 표시
            if viewModel.isLoading && !viewModel.users.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("더 불러오는 중...")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            await viewModel.searchUsers()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: viewModel.currentSearchMode == .api ? "magnifyingglass" : "heart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(viewModel.currentSearchMode == .api ? "사용자를 검색해보세요" : "즐겨찾기한 사용자가 없습니다")
                .font(.title2)
                .foregroundColor(.gray)
            
            if viewModel.currentSearchMode == .api {
                Text("GitHub 사용자 이름을 입력하고 검색해보세요")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.2)
            Text("검색 중...")
                .font(.body)
                .foregroundColor(.gray)
                
            Spacer()
        }
    }
}

#Preview {
    let mockSearchUseCase = MockSearchUserUseCase()
    let mockFavoriteUseCase = MockFavoriteUserUseCase()
    
    let viewModel = SearchUsersViewModel(
        searchUserUseCase: mockSearchUseCase,
        favoriteUserUseCase: mockFavoriteUseCase
    )
    
    return SearchUsersView(viewModel: viewModel)
}

// MARK: - Mock Classes for Preview
private class MockSearchUserUseCase: SearchUserUseCase {
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        return SearchResult(totalCount: 0, incompleteResults: false, items: [])
    }
    
    func searchFavoriteUsers(query: String) async throws -> SearchResult {
        return SearchResult(totalCount: 0, incompleteResults: false, items: [])
    }
}

private class MockFavoriteUserUseCase: FavoriteUserUseCase {
    func addFavoriteUser(_ user: GitUser) async throws {}
    func removeFavoriteUser(_ user: GitUser) async throws {}
    func getFavoriteUsers() async throws -> [GitUser] { return [] }
    func isFavoriteUser(_ user: GitUser) async throws -> Bool { return false }
    func toggleFavoriteUser(_ user: GitUser) async throws {}
} 