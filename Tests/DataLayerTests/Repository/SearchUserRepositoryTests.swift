import XCTest
@testable import DataLayer
@testable import DomainLayer

final class SearchUserRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    var sut: SearchUserRepository!
    var mockAPIService: MockGitHubAPIService!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockAPIService = MockGitHubAPIService()
        sut = SearchUserRepository(apiService: mockAPIService)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    // BDD: SearchUserRepository 초기화 성공
    func test_searchUserRepository_initialization_shouldSucceed() {
        // Given/When: SearchUserRepository가 초기화되었을 때
        // Then: 정상적으로 생성된다
        XCTAssertNotNil(sut)
    }
    
    // BDD: 기본 검색 기능
    func test_searchUsers_withValidParameters_shouldReturnSearchResult() async throws {
        // Given: 유효한 검색 파라미터가 주어졌을 때
        let parameters = SearchParameters.mockParameters
        let expectedResult = SearchResult.mockResult
        mockAPIService.mockResult = .success(expectedResult)
        
        // When: searchUsers를 호출하면
        let result = try await sut.searchUsers(parameters: parameters)
        
        // Then: 검색 결과가 반환된다
        XCTAssertEqual(result.totalCount, expectedResult.totalCount)
        XCTAssertEqual(result.items.count, expectedResult.items.count)
        XCTAssertEqual(mockAPIService.searchCallCount, 1)
        XCTAssertEqual(mockAPIService.lastSearchParameters?.query, parameters.query)
    }
    
    // BDD: 네트워크 오류로 검색 실패
    func test_searchUsers_withNetworkError_shouldThrowError() async {
        // Given: API 서비스에서 네트워크 오류가 발생할 때
        let parameters = SearchParameters.mockParameters
        mockAPIService.mockResult = .failure(MockError.networkError)
        
        // When/Then: searchUsers를 호출하면 에러가 발생한다
        await assertThrowsError(try await sut.searchUsers(parameters: parameters)) { error in
            XCTAssertEqual(error as? MockError, MockError.networkError)
        }
    }
    
    // BDD: 빈 검색 결과 처리
    func test_searchUsers_withEmptyResult_shouldReturnEmptySearchResult() async throws {
        // Given: 빈 검색 결과가 반환될 때
        let parameters = SearchParameters.mockParameters
        let emptyResult = SearchResult(totalCount: 0, incompleteResults: false, items: [])
        mockAPIService.mockResult = .success(emptyResult)
        
        // When: searchUsers를 호출하면
        let result = try await sut.searchUsers(parameters: parameters)
        
        // Then: 빈 검색 결과가 반환된다
        XCTAssertEqual(result.totalCount, 0)
        XCTAssertTrue(result.items.isEmpty)
        XCTAssertFalse(result.incompleteResults)
    }
    
    // BDD: 페이지네이션 파라미터 전달 확인
    func test_searchUsers_shouldPassCorrectParameters() async throws {
        // Given: 특정 페이지와 개수가 설정된 검색 파라미터가 주어졌을 때
        let parameters = SearchParameters(query: "swift", page: 2, perPage: 50)
        let expectedResult = SearchResult.mockResult
        mockAPIService.mockResult = .success(expectedResult)
        
        // When: searchUsers를 호출하면
        _ = try await sut.searchUsers(parameters: parameters)
        
        // Then: 올바른 파라미터가 API 서비스에 전달된다
        XCTAssertEqual(mockAPIService.lastSearchParameters?.query, "swift")
        XCTAssertEqual(mockAPIService.lastSearchParameters?.page, 2)
        XCTAssertEqual(mockAPIService.lastSearchParameters?.perPage, 50)
    }
    
    // BDD: API 호출 횟수 확인
    func test_searchUsers_shouldCallAPIServiceOnce() async throws {
        // Given: 유효한 검색 파라미터가 주어졌을 때
        let parameters = SearchParameters.mockParameters
        let expectedResult = SearchResult.mockResult
        mockAPIService.mockResult = .success(expectedResult)
        
        // When: searchUsers를 호출하면
        _ = try await sut.searchUsers(parameters: parameters)
        
        // Then: API 서비스가 정확히 한 번 호출된다
        XCTAssertEqual(mockAPIService.searchCallCount, 1)
    }
}
