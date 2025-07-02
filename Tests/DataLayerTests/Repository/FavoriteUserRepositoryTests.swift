import XCTest
@testable import DataLayer
@testable import DomainLayer

final class FavoriteUserRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    var sut: FavoriteUserRepository!
    var mockLocalService: MockFavoriteUserLocalService!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockLocalService = MockFavoriteUserLocalService()
        sut = FavoriteUserRepository(localService: mockLocalService)
    }
    
    override func tearDown() {
        sut = nil
        mockLocalService = nil
        super.tearDown()
    }
    
    // BDD: FavoriteUserRepository 초기화 성공
    func test_favoriteUserRepository_initialization_shouldSucceed() {
        // Given/When: FavoriteUserRepository가 초기화되었을 때
        // Then: 정상적으로 생성된다
        XCTAssertNotNil(sut)
    }
    
    // BDD: 즐겨찾기 사용자 추가 성공
    func test_addFavoriteUser_withValidUser_shouldSucceed() async throws {
        // Given: 유효한 GitUser 객체가 주어졌을 때
        let user = GitUser.mockUser
        
        // When: addFavoriteUser 메서드를 호출하면
        try await sut.addFavoriteUser(user)
        
        // Then: 사용자가 로컬 저장소에 추가된다
        XCTAssertTrue(mockLocalService.mockUsers.contains { $0.id == user.id })
    }
    
    // BDD: 즐겨찾기 사용자 제거 성공
    func test_removeFavoriteUser_withExistingUser_shouldSucceed() async throws {
        // Given: 즐겨찾기에 있는 사용자가 주어졌을 때
        let user = GitUser.mockUser
        mockLocalService.mockUsers = [user]
        
        // When: removeFavoriteUser 메서드를 호출하면
        try await sut.removeFavoriteUser(user)
        
        // Then: 사용자가 즐겨찾기에서 제거된다
        XCTAssertFalse(mockLocalService.mockUsers.contains { $0.id == user.id })
    }
    
    // BDD: 즐겨찾기 사용자 조회 성공
    func test_getFavoriteUsers_shouldReturnAllFavoriteUsers() async throws {
        // Given: 로컬 저장소에 즐겨찾기 사용자들이 있을 때
        let users = [GitUser.mockUser, GitUser.mockUser2]
        mockLocalService.mockUsers = users
        
        // When: getFavoriteUsers 메서드를 호출하면
        let result = try await sut.getFavoriteUsers()
        
        // Then: 저장된 모든 즐겨찾기 사용자 목록이 반환된다
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, GitUser.mockUser.id)
        XCTAssertEqual(result[1].id, GitUser.mockUser2.id)
    }
    
    // BDD: 즐겨찾기 상태 확인 - 즐겨찾기에 있는 사용자
    func test_isFavoriteUser_withFavoriteUser_shouldReturnTrue() async throws {
        // Given: 즐겨찾기에 있는 사용자가 주어졌을 때
        let user = GitUser.mockUser
        mockLocalService.mockUsers = [user]
        
        // When: isFavoriteUser 메서드를 호출하면
        let isFavorite = try await sut.isFavoriteUser(user)
        
        // Then: true가 반환된다
        XCTAssertTrue(isFavorite)
    }
    
    // BDD: 즐겨찾기 상태 확인 - 즐겨찾기에 없는 사용자
    func test_isFavoriteUser_withNonFavoriteUser_shouldReturnFalse() async throws {
        // Given: 즐겨찾기에 없는 사용자가 주어졌을 때
        let user = GitUser.mockUser
        mockLocalService.mockUsers = []
        
        // When: isFavoriteUser 메서드를 호출하면
        let isFavorite = try await sut.isFavoriteUser(user)
        
        // Then: false가 반환된다
        XCTAssertFalse(isFavorite)
    }
} 