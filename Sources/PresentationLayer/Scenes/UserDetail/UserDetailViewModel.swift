import Foundation
import Observation
import DomainLayer

@Observable
public class UserDetailViewModel {
    
    // MARK: - State
    public var userDetail: UserDetail?
    public var repositories: [Repository] = []
    public var isLoading = false
    public var errorMessage: String?
    
    // MARK: - Dependencies
    private let userDetailUseCase: UserDetailUseCase
    
    // MARK: - Initialization
    public init(userDetailUseCase: UserDetailUseCase) {
        self.userDetailUseCase = userDetailUseCase
    }
    
    // MARK: - Public Methods
    @MainActor
    public func loadUserDetail(username: String) async {
        guard !username.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let userDetailTask = userDetailUseCase.getUserDetail(username: username)
            async let repositoriesTask = userDetailUseCase.getUserRepositories(username: username)
            
            let (userDetail, repositories) = try await (userDetailTask, repositoriesTask)
            
            self.userDetail = userDetail
            self.repositories = repositories
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    public func retry(username: String) async {
        await loadUserDetail(username: username)
    }
} 