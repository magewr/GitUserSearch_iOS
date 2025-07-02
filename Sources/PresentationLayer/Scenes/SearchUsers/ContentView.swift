import SwiftUI
import DomainLayer
import DataLayer

public struct ContentView: View {
    @State private var viewModel = SearchUsersViewModel(
        searchUserUseCase: DIContainer.shared.searchUserUseCase,
        favoriteUserUseCase: DIContainer.shared.favoriteUserUseCase
    )
    
    public init() {}
    
    public var body: some View {
        SearchUsersView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
} 