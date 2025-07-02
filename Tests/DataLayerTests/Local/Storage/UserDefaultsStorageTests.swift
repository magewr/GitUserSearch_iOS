import XCTest
@testable import DataLayer

final class UserDefaultsStorageTests: XCTestCase {
    
    // MARK: - Properties
    var sut: UserDefaultsStorage!
    private let testKey = "test_key"
    private let testValue = "test_value"
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        sut = UserDefaultsStorage()
        // 테스트 데이터 정리
        UserDefaults.standard.removeObject(forKey: testKey)
    }
    
    override func tearDown() {
        // 테스트 후 정리
        UserDefaults.standard.removeObject(forKey: testKey)
        sut = nil
        super.tearDown()
    }
    
    // BDD: UserDefaultsStorage 초기화 성공
    func test_userDefaultsStorage_initialization_shouldSucceed() {
        // Given/When: UserDefaultsStorage가 초기화되었을 때
        // Then: 정상적으로 생성된다
        XCTAssertNotNil(sut)
    }
    
    // BDD: 데이터 저장 성공
    func test_save_withValidData_shouldSucceed() throws {
        // Given: 저장할 데이터가 주어졌을 때
        let dataToSave = testValue
        
        // When: save 메서드를 호출하면
        try sut.save(dataToSave, forKey: testKey)
        
        // Then: 데이터가 성공적으로 저장된다
        XCTAssertTrue(sut.exists(forKey: testKey))
    }
    
    // BDD: 데이터 조회 성공
    func test_load_withExistingData_shouldReturnData() throws {
        // Given: 저장된 데이터가 있을 때
        try sut.save(testValue, forKey: testKey)
        
        // When: load 메서드를 호출하면
        let loadedData = try sut.load(String.self, forKey: testKey)
        
        // Then: 저장된 데이터가 반환된다
        XCTAssertEqual(loadedData, testValue)
    }
    
    // BDD: 존재하지 않는 데이터 조회
    func test_load_withNonExistingData_shouldReturnNil() throws {
        // Given: 저장되지 않은 키가 주어졌을 때
        let nonExistingKey = "non_existing_key"
        
        // When: load 메서드를 호출하면
        let loadedData = try sut.load(String.self, forKey: nonExistingKey)
        
        // Then: nil이 반환된다
        XCTAssertNil(loadedData)
    }
    
    // BDD: 데이터 존재 여부 확인 - 존재하는 경우
    func test_exists_withExistingData_shouldReturnTrue() throws {
        // Given: 저장된 데이터가 있을 때
        try sut.save(testValue, forKey: testKey)
        
        // When: exists 메서드를 호출하면
        let exists = sut.exists(forKey: testKey)
        
        // Then: true가 반환된다
        XCTAssertTrue(exists)
    }
    
    // BDD: 데이터 존재 여부 확인 - 존재하지 않는 경우
    func test_exists_withNonExistingData_shouldReturnFalse() {
        // Given: 저장되지 않은 키가 주어졌을 때
        let nonExistingKey = "non_existing_key"
        
        // When: exists 메서드를 호출하면
        let exists = sut.exists(forKey: nonExistingKey)
        
        // Then: false가 반환된다
        XCTAssertFalse(exists)
    }
    
    // BDD: 데이터 제거 성공
    func test_remove_withExistingData_shouldRemoveData() throws {
        // Given: 저장된 데이터가 있을 때
        try sut.save(testValue, forKey: testKey)
        XCTAssertTrue(sut.exists(forKey: testKey))
        
        // When: remove 메서드를 호출하면
        sut.remove(forKey: testKey)
        
        // Then: 데이터가 제거된다
        XCTAssertFalse(sut.exists(forKey: testKey))
    }
    
    // BDD: 복잡한 객체 저장 및 조회
    func test_saveAndLoad_withComplexObject_shouldSucceed() throws {
        // Given: 복잡한 객체가 주어졌을 때
        struct TestModel: Codable, Equatable {
            let id: Int
            let name: String
        }
        let testModel = TestModel(id: 123, name: "TestName")
        let complexKey = "complex_object_key"
        
        // When: 객체를 저장하고 조회하면
        try sut.save(testModel, forKey: complexKey)
        let loadedModel = try sut.load(TestModel.self, forKey: complexKey)
        
        // Then: 동일한 객체가 반환된다
        XCTAssertEqual(loadedModel, testModel)
        
        // 정리
        sut.remove(forKey: complexKey)
    }
} 