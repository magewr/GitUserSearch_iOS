import XCTest
@testable import DomainLayer

@MainActor
final class FavoriteUserUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    var sut: DefaultFavoriteUserUseCase!
    var mockFavoriteUserInteractor: MockFavoriteUserInteractor!
    
    // MARK: - Setup & Teardown
    override func setUp() async throws {
        try await super.setUp()
        mockFavoriteUserInteractor = MockFavoriteUserInteractor()
        sut = DefaultFavoriteUserUseCase(
            favoriteUserInteractor: mockFavoriteUserInteractor
        )
    }
    
    override func tearDown() {
        sut = nil
        mockFavoriteUserInteractor = nil
        super.tearDown()
    }
    
    // MARK: - 즐겨찾기 추가 테스트
    
    // BDD: 새로운 사용자 즐겨찾기 추가 성공
    func test_addFavoriteUser_withNewUser_shouldSucceed() async throws {
        // Given: 새로운 사용자가 주어졌을 때
        let user = GitUser.mockUser
        
        // When: 즐겨찾기에 추가하면
        try await sut.addFavoriteUser(user)
        
        // Then: 사용자가 즐겨찾기에 추가된다
        XCTAssertTrue(mockFavoriteUserInteractor.mockUsers.contains { $0.id == user.id })
    }
    
    // BDD: 즐겨찾기 제거 성공
    func test_removeFavoriteUser_withExistingUser_shouldSucceed() async throws {
        // Given: 즐겨찾기에 있는 사용자가 주어졌을 때
        let user = GitUser.mockUser
        mockFavoriteUserInteractor.mockUsers = [user]
        
        // When: 즐겨찾기에서 제거하면
        try await sut.removeFavoriteUser(user)
        
        // Then: 사용자가 즐겨찾기에서 제거된다
        XCTAssertFalse(mockFavoriteUserInteractor.mockUsers.contains { $0.id == user.id })
    }
    
    // BDD: 즐겨찾기 목록 조회 성공
    func test_getFavoriteUsers_shouldReturnUsers() async throws {
        // Given: 즐겨찾기에 사용자들이 있을 때
        let users = [GitUser.mockUser, GitUser.mockUser2]
        mockFavoriteUserInteractor.mockUsers = users
        
        // When: 즐겨찾기 목록을 조회하면
        let result = try await sut.getFavoriteUsers()
        
        // Then: 올바른 사용자 목록이 반환된다
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, GitUser.mockUser.id)
        XCTAssertEqual(result[1].id, GitUser.mockUser2.id)
    }
    
    // BDD: 즐겨찾기 여부 확인 성공
    func test_isFavoriteUser_withFavoriteUser_shouldReturnTrue() async throws {
        // Given: 즐겨찾기에 있는 사용자가 주어졌을 때
        let user = GitUser.mockUser
        mockFavoriteUserInteractor.mockUsers = [user]
        
        // When: 즐겨찾기 여부를 확인하면
        let isFavorite = try await sut.isFavoriteUser(user)
        
        // Then: true가 반환된다
        XCTAssertTrue(isFavorite)
    }
    
    // BDD: 즐겨찾기 토글 기능 테스트
    func test_toggleFavoriteUser_withNewUser_shouldAddToFavorites() async throws {
        // Given: 즐겨찾기에 없는 사용자가 주어졌을 때
        let user = GitUser.mockUser
        XCTAssertTrue(mockFavoriteUserInteractor.mockUsers.isEmpty)
        
        // When: 즐겨찾기를 토글하면
        try await sut.toggleFavoriteUser(user)
        
        // Then: 사용자가 즐겨찾기에 추가된다
        XCTAssertTrue(mockFavoriteUserInteractor.mockUsers.contains { $0.id == user.id })
    }
    
    func test_toggleFavoriteUser_withExistingUser_shouldRemoveFromFavorites() async throws {
        // Given: 즐겨찾기에 있는 사용자가 주어졌을 때
        let user = GitUser.mockUser
        mockFavoriteUserInteractor.mockUsers = [user]
        
        // When: 즐겨찾기를 토글하면
        try await sut.toggleFavoriteUser(user)
        
        // Then: 사용자가 즐겨찾기에서 제거된다
        XCTAssertFalse(mockFavoriteUserInteractor.mockUsers.contains { $0.id == user.id })
    }
} 