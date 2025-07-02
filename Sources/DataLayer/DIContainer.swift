import Foundation
import DomainLayer

public protocol DIContainerProtocol {
    var searchUserUseCase: SearchUserUseCase { get }
    var favoriteUserUseCase: FavoriteUserUseCase { get }
}

public class DIContainer: DIContainerProtocol {
    public static let shared: DIContainerProtocol = DIContainer()
    
    // MARK: - Dependencies
    private let localStorage: LocalStorageProtocol
    private let networkClient: NetworkClientProtocol
    private let gitHubAPIService: GitHubAPIServiceProtocol
    private let favoriteUserLocalService: FavoriteUserLocalServiceProtocol
    private let searchUserRepository: SearchUserDataProtocol
    private let favoriteUserRepository: FavoriteUserDataProtocol
    private let searchUserInteractor: SearchUserInteractor
    private let favoriteUserInteractor: FavoriteUserInteractor
    
    // MARK: - Public Use Cases
    public let searchUserUseCase: SearchUserUseCase
    public let favoriteUserUseCase: FavoriteUserUseCase
    
    // MARK: - Initializers
    public init(
        localStorage: LocalStorageProtocol? = nil,
        networkClient: NetworkClientProtocol? = nil
    ) {
        // Storage
        self.localStorage = localStorage ?? UserDefaultsStorage()
        
        // Network
        self.networkClient = networkClient ?? NetworkClient()
        
        // API Services
        self.gitHubAPIService = GitHubAPIService(networkClient: self.networkClient)
        
        // Local Services
        self.favoriteUserLocalService = FavoriteUserLocalService(storage: self.localStorage)
        
        // Repositories
        self.searchUserRepository = SearchUserRepository(apiService: self.gitHubAPIService)
        self.favoriteUserRepository = FavoriteUserRepository(localService: self.favoriteUserLocalService)
        
        // Interactors
        self.searchUserInteractor = DefaultSearchUserInteractor(dataProtocol: self.searchUserRepository)
        self.favoriteUserInteractor = DefaultFavoriteUserInteractor(dataProtocol: self.favoriteUserRepository)
        
        // Use Cases
        self.searchUserUseCase = DefaultSearchUserUseCase(
            searchUserInteractor: self.searchUserInteractor,
            favoriteUserInteractor: self.favoriteUserInteractor
        )
        
        self.favoriteUserUseCase = DefaultFavoriteUserUseCase(
            favoriteUserInteractor: self.favoriteUserInteractor
        )
    }
}

// MARK: - Test Helper
public extension DIContainer {
    /// 테스트용 DIContainer 생성
    static func makeForTesting(
        localStorage: LocalStorageProtocol? = nil,
        networkClient: NetworkClientProtocol? = nil
    ) -> DIContainerProtocol {
        return DIContainer(
            localStorage: localStorage,
            networkClient: networkClient
        )
    }
} 