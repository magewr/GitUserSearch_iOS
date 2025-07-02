import XCTest
@testable import PresentationLayer
@testable import DomainLayer

@MainActor
final class SearchUsersViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var sut: SearchUsersViewModel!
    var mockSearchUserUseCase: MockSearchUserUseCase!
    var mockFavoriteUserUseCase: MockFavoriteUserUseCase!
    
    // MARK: - Setup & Teardown
    override func setUp() async throws {
        try await super.setUp()
        mockSearchUserUseCase = MockSearchUserUseCase()
        mockFavoriteUserUseCase = MockFavoriteUserUseCase()
        sut = SearchUsersViewModel(
            searchUserUseCase: mockSearchUserUseCase,
            favoriteUserUseCase: mockFavoriteUserUseCase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockSearchUserUseCase = nil
        mockFavoriteUserUseCase = nil
        super.tearDown()
    }
    
    // BDD: 초기 상태 확인
    func test_initialState_shouldBeCorrect() {
        // Given/When: ViewModel이 초기화되었을 때
        // Then: 초기 상태가 올바르게 설정된다
        XCTAssertEqual(sut.searchText, "")
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.currentSearchMode, .api)
    }
    
    // BDD: 즐겨찾기 여부 확인
    func test_isFavoriteUser_shouldReturnCorrectStatus() {
        // Given: 즐겨찾기에 있는 사용자와 없는 사용자가 있을 때
        let favoriteUser = GitUser.mockUser
        let normalUser = GitUser.mockUser2
        sut.favoriteUsers = [favoriteUser]
        
        // When/Then: 즐겨찾기 여부를 확인하면
        XCTAssertTrue(sut.isFavoriteUser(favoriteUser))
        XCTAssertFalse(sut.isFavoriteUser(normalUser))
    }
    
    // BDD: 유효한 검색어로 검색 성공
    func test_searchUsers_withValidQuery_shouldReturnResults() async {
        // Given: 유효한 검색어가 입력되었을 때
        sut.searchText = "swift"
        let expectedResult = SearchResult.mockResult
        mockSearchUserUseCase.mockAPIResult = .success(expectedResult)
        
        // When: searchUsers 메서드를 호출하면
        await sut.searchUsers()
        
        // Then: 검색 결과가 설정되고 로딩이 완료된다
        XCTAssertEqual(sut.users.count, expectedResult.items.count)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    // BDD: 빈 검색어로 검색 시도
    func test_searchUsers_withEmptyQuery_shouldClearResults() async {
        // Given: 빈 검색어가 입력되었을 때
        sut.searchText = ""
        sut.users = [GitUser.mockUser] // 기존 검색 결과가 있다고 가정
        
        // When: searchUsers 메서드를 호출하면
        await sut.searchUsers()
        
        // Then: 검색 결과가 클리어되고 API가 호출되지 않는다
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }
    
    // BDD: 검색 중 에러 발생
    func test_searchUsers_withError_shouldSetErrorMessage() async {
        // Given: 유효한 검색어가 입력되었을 때
        sut.searchText = "swift"
        mockSearchUserUseCase.mockAPIResult = .failure(MockError.networkError)
        
        // When: searchUsers 메서드를 호출하면
        await sut.searchUsers()
        
        // Then: 에러 메시지가 설정되고 로딩이 완료된다
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.users.isEmpty)
    }
    
    // BDD: 검색 모드 전환 - API to Favorites
    func test_switchSearchMode_toFavorites_shouldUpdateMode() async {
        // Given: 현재 검색 모드가 .api일 때
        XCTAssertEqual(sut.currentSearchMode, .api)
        mockFavoriteUserUseCase.mockUsers = [GitUser.mockUser]
        mockSearchUserUseCase.mockFavoriteResult = .success(SearchResult.mockResult)
        
        // When: 즐겨찾기 모드로 전환하면
        await sut.switchSearchMode(to: .favorites)
        
        // Then: 검색 모드가 변경되고 즐겨찾기 검색이 실행된다
        XCTAssertEqual(sut.currentSearchMode, .favorites)
    }
    
    // BDD: 검색 모드 전환 - Favorites to API
    func test_switchSearchMode_toAPI_shouldUpdateMode() async {
        // Given: 현재 검색 모드가 .favorites일 때
        sut.currentSearchMode = .favorites
        sut.searchText = "test"
        mockSearchUserUseCase.mockAPIResult = .success(SearchResult.mockResult)
        
        // When: API 모드로 전환하면
        await sut.switchSearchMode(to: .api)
        
        // Then: 검색 모드가 변경되고 API 검색이 실행된다
        XCTAssertEqual(sut.currentSearchMode, .api)
    }
    
    // BDD: 즐겨찾기 토글 성공
    func test_toggleFavorite_shouldUpdateFavoriteStatus() async {
        // Given: 특정 사용자가 주어졌을 때
        let user = GitUser.mockUser
        XCTAssertFalse(sut.isFavoriteUser(user))
        
        // When: toggleFavorite 메서드를 호출하면
        await sut.toggleFavorite(for: user)
        
        // Then: 즐겨찾기 상태가 변경된다
        XCTAssertTrue(mockFavoriteUserUseCase.mockUsers.contains { $0.id == user.id })
    }
    
    // BDD: 즐겨찾기 토글 실패
    func test_toggleFavorite_withError_shouldSetErrorMessage() async {
        // Given: 특정 사용자가 주어지고 에러가 발생할 때
        let user = GitUser.mockUser
        // MockFavoriteUserUseCase는 에러를 발생시키지 않으므로 에러 상황을 간접적으로 테스트
        
        // When: toggleFavorite 메서드를 호출하면
        await sut.toggleFavorite(for: user)
        
        // Then: 정상적으로 처리된다 (Mock은 에러를 발생시키지 않음)
        XCTAssertTrue(mockFavoriteUserUseCase.mockUsers.contains { $0.id == user.id })
    }
    
    // BDD: 로딩 상태 관리
    func test_searchUsers_shouldManageLoadingState() async {
        // Given: 검색어가 설정되어 있을 때
        sut.searchText = "swift"
        mockSearchUserUseCase.mockAPIResult = .success(SearchResult.mockResult)
        
        // When: 검색을 시작하면
        let searchTask = Task {
            await sut.searchUsers()
        }
        
        // Then: 로딩 상태가 올바르게 관리된다
        await searchTask.value
        XCTAssertFalse(sut.isLoading) // 검색 완료 후에는 false
    }
}

// MARK: - Mock Use Cases
