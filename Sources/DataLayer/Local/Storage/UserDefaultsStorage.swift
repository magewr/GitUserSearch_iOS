import Foundation
import DomainLayer

public protocol LocalStorageProtocol {
    func save<T: Codable>(_ object: T, forKey key: String) throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?
    func remove(forKey key: String)
    func exists(forKey key: String) -> Bool
}

public class UserDefaultsStorage: LocalStorageProtocol {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    public func save<T: Codable>(_ object: T, forKey key: String) throws {
        let data = try encoder.encode(object)
        userDefaults.set(data, forKey: key)
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return try decoder.decode(type, from: data)
    }
    
    public func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    public func exists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
}

public enum StorageError: LocalizedError {
    case encodingFailed(Error)
    case decodingFailed(Error)
    case notFound
    
    public var errorDescription: String? {
        switch self {
        case .encodingFailed(let error):
            return "데이터 저장 실패: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "데이터 로드 실패: \(error.localizedDescription)"
        case .notFound:
            return "데이터를 찾을 수 없습니다."
        }
    }
} 