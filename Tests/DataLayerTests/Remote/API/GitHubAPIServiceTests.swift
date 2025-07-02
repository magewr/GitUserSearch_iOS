import XCTest
@testable import DataLayer
@testable import DomainLayer

final class GitHubAPIServiceTests: XCTestCase {
    
    // MARK: - Properties
    var sut: GitHubAPIService!
    var mockNetworkClient: MockNetworkClient!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        sut = GitHubAPIService(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkClient = nil
        super.tearDown()
    }
    
    // BDD: GitHubAPIService 초기화 성공
    func test_gitHubAPIService_initialization_shouldSucceed() {
        // Given/When: GitHubAPIService가 초기화되었을 때
        // Then: 정상적으로 생성된다
        XCTAssertNotNil(sut)
    }
    
    // BDD: 유효한 검색 파라미터로 API 호출 성공
    func test_searchUsers_withValidParameters_shouldReturnSearchResult() async throws {
        // Given: 유효한 SearchParameters가 주어졌을 때
        let parameters = SearchParameters.mockParameters
        let expectedResult = SearchResult.mockResult
        mockNetworkClient.mockResult = .success(expectedResult)
        
        // When: searchUsers 메서드를 호출하면
        let result = try await sut.searchUsers(parameters: parameters)
        
        // Then: SearchResult가 반환된다
        XCTAssertEqual(result.totalCount, expectedResult.totalCount)
        XCTAssertEqual(result.items.count, expectedResult.items.count)
        XCTAssertEqual(result.incompleteResults, expectedResult.incompleteResults)
    }
    
    // BDD: 네트워크 오류로 API 호출 실패
    func test_searchUsers_withNetworkError_shouldThrowError() async {
        // Given: NetworkClient에서 네트워크 오류가 발생할 때
        let parameters = SearchParameters.mockParameters
        mockNetworkClient.mockResult = .failure(MockError.networkError)
        
        // When/Then: searchUsers 메서드를 호출하면 에러가 발생한다
        await assertThrowsError(try await sut.searchUsers(parameters: parameters)) { error in
            XCTAssertEqual(error as? MockError, MockError.networkError)
        }
    }
    
    // BDD: API 호출 한도 초과 시뮬레이션
    func test_searchUsers_withRateLimitError_shouldThrowError() async {
        // Given: API 호출 한도가 초과된 상황을 시뮬레이션할 때
        let parameters = SearchParameters.mockParameters
        mockNetworkClient.mockResult = .failure(MockError.timeout)
        
        // When/Then: searchUsers 메서드를 호출하면 타임아웃 에러가 발생한다
        await assertThrowsError(try await sut.searchUsers(parameters: parameters)) { error in
            XCTAssertEqual(error as? MockError, MockError.timeout)
        }
    }
    
    // BDD: 검색 파라미터 검증
    func test_searchParameters_shouldHaveValidProperties() {
        // Given: SearchParameters가 생성되었을 때
        let parameters = SearchParameters.mockParameters
        
        // When/Then: 올바른 속성들을 가진다
        XCTAssertEqual(parameters.query, "test")
        XCTAssertEqual(parameters.page, 1)
        XCTAssertEqual(parameters.perPage, 30)
    }
} 