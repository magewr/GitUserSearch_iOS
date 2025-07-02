import XCTest
@testable import DomainLayer

@MainActor
final class SearchUserUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    var sut: DefaultSearchUserUseCase!
    var mockSearchUserInteractor: MockSearchUserInteractor!
    var mockFavoriteUserInteractor: MockFavoriteUserInteractor!
    
    // MARK: - Setup & Teardown
    override func setUp() async throws {
        try await super.setUp()
        mockSearchUserInteractor = MockSearchUserInteractor()
        mockFavoriteUserInteractor = MockFavoriteUserInteractor()
        sut = DefaultSearchUserUseCase(
            searchUserInteractor: mockSearchUserInteractor,
            favoriteUserInteractor: mockFavoriteUserInteractor
        )
    }
    
    override func tearDown() {
        sut = nil
        mockSearchUserInteractor = nil
        mockFavoriteUserInteractor = nil
        super.tearDown()
    }
    
    // MARK: - API 검색 테스트
    
    // BDD: 유효한 검색 파라미터로 API 검색 성공
    func test_searchUsers_withValidParameters_shouldReturnSearchResult() async throws {
        // Given: 유효한 검색 파라미터가 주어졌을 때
        let parameters = SearchParameters.mockParameters
        let expectedResult = SearchResult.mockResult
        mockSearchUserInteractor.mockResult = .success(expectedResult)
        
        // When: searchUsers를 호출하면
        let result = try await sut.searchUsers(parameters: parameters)
        
        // Then: 올바른 검색 결과가 반환된다
        XCTAssertEqual(result.totalCount, expectedResult.totalCount)
        XCTAssertEqual(result.items.count, expectedResult.items.count)
    }
    
    // BDD: 즐겨찾기 검색 성공
    func test_searchFavoriteUsers_withValidQuery_shouldReturnFilteredResult() async throws {
        // Given: 즐겨찾기 사용자들이 있을 때
        let favoriteUsers = [GitUser.mockUser, GitUser.mockUser2]
        mockFavoriteUserInteractor.mockUsers = favoriteUsers
        
        // When: 즐겨찾기 검색을 수행하면
        let result = try await sut.searchFavoriteUsers(query: "test")
        
        // Then: 필터링된 결과가 반환된다
        XCTAssertNotNil(result)
        XCTAssertGreaterThanOrEqual(result.totalCount, 0)
        XCTAssertFalse(result.incompleteResults)
    }
    
    // BDD: 빈 검색어로 즐겨찾기 검색
    func test_searchFavoriteUsers_withEmptyQuery_shouldReturnAllFavorites() async throws {
        // Given: 즐겨찾기 사용자들이 있을 때
        let favoriteUsers = [GitUser.mockUser, GitUser.mockUser2]
        mockFavoriteUserInteractor.mockUsers = favoriteUsers
        
        // When: 빈 검색어로 즐겨찾기 검색을 수행하면
        let result = try await sut.searchFavoriteUsers(query: "")
        
        // Then: 모든 즐겨찾기 사용자가 반환된다
        XCTAssertEqual(result.totalCount, 2)
        XCTAssertEqual(result.items.count, 2)
    }
    
    // BDD: API 검색 실패
    func test_searchUsers_withError_shouldThrowError() async {
        // Given: SearchUserInteractor에서 에러가 발생할 때
        let parameters = SearchParameters.mockParameters
        mockSearchUserInteractor.mockResult = .failure(MockError.networkError)
        
        // When/Then: searchUsers를 호출하면 에러가 발생한다
        await assertThrowsError(try await sut.searchUsers(parameters: parameters)) { error in
            XCTAssertEqual(error as? MockError, MockError.networkError)
        }
    }
}

// MARK: - Mock Objects
