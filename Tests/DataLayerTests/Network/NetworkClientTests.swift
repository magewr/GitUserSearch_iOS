import XCTest
@testable import DataLayer

final class NetworkClientTests: XCTestCase {
    
    // MARK: - Properties
    var sut: NetworkClient!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        sut = NetworkClient()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // BDD: NetworkClient 초기화 성공
    func test_networkClient_initialization_shouldSucceed() {
        // Given/When: NetworkClient가 초기화되었을 때
        // Then: 정상적으로 생성된다
        XCTAssertNotNil(sut)
    }
    
    // BDD: 유효한 Endpoint 객체 생성
    func test_endpoint_withValidParameters_shouldCreateCorrectURL() {
        // Given: 유효한 파라미터가 주어졌을 때
        let endpoint = MockEndpoint.validEndpoint
        
        // When: URL을 생성하면
        let url = endpoint.url
        
        // Then: 올바른 URL이 생성된다
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("api.github.com") == true)
        XCTAssertTrue(url?.absoluteString.contains("/search/users") == true)
        XCTAssertTrue(url?.absoluteString.contains("q=test") == true)
    }
    
    // BDD: HTTP Method 정의 확인
    func test_httpMethod_shouldHaveCorrectRawValues() {
        // Given/When/Then: HTTP Method들이 올바른 값을 가진다
        XCTAssertEqual(HTTPMethod.GET.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.POST.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.PUT.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.DELETE.rawValue, "DELETE")
    }
}
