import SwiftUI
import DomainLayer

public struct UserDetailView: View {
    let username: String
    @State private var viewModel: UserDetailViewModel
    
    public init(username: String, userDetailUseCase: UserDetailUseCase) {
        self.username = username
        self._viewModel = State(initialValue: UserDetailViewModel(userDetailUseCase: userDetailUseCase))
    }
    
    public var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                loadingView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if let userDetail = viewModel.userDetail {
                contentView(userDetail)
            } else {
                EmptyView()
            }
        }
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadUserDetail(username: username)
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("사용자 정보를 불러오는 중...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("오류가 발생했습니다")
                .font(.headline)
            
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("다시 시도") {
                Task {
                    await viewModel.retry(username: username)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Content View
    private func contentView(_ userDetail: UserDetail) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                userInfoSection(userDetail)
                repositoriesSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    // MARK: - User Info Section
    private func userInfoSection(_ userDetail: UserDetail) -> some View {
        VStack(spacing: 16) {
            // 프로필 이미지
            AsyncImage(url: URL(string: userDetail.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 40))
                    )
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            
            // 기본 정보
            VStack(spacing: 8) {
                if let name = userDetail.name, !name.isEmpty {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Text("@\(userDetail.login)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                if let bio = userDetail.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            // 상세 정보
            VStack(spacing: 12) {
                if let company = userDetail.company, !company.isEmpty {
                    infoRow(icon: "building.2", text: company)
                }
                
                if let location = userDetail.location, !location.isEmpty {
                    infoRow(icon: "location", text: location)
                }
                
                if let blog = userDetail.blog, !blog.isEmpty {
                    infoRow(icon: "link", text: blog)
                }
                
                if let email = userDetail.email, !email.isEmpty {
                    infoRow(icon: "envelope", text: email)
                }
            }
            
            // 통계
            HStack(spacing: 24) {
                statItem(title: "Repositories", value: userDetail.publicRepos)
                statItem(title: "Followers", value: userDetail.followers)
                statItem(title: "Following", value: userDetail.following)
                statItem(title: "Gists", value: userDetail.publicGists)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Info Row
    private func infoRow(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
            Text(text)
                .font(.body)
            Spacer()
        }
    }
    
    // MARK: - Stat Item
    private func statItem(title: String, value: Int) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.headline)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Repositories Section
    private var repositoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Public Repositories")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("\(viewModel.repositories.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if viewModel.repositories.isEmpty {
                Text("공개 저장소가 없습니다.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.repositories) { repository in
                        repositoryCard(repository)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Repository Card
    private func repositoryCard(_ repository: Repository) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(repository.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !repository.isPrivate {
                    Image(systemName: "lock.open")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            
            if let description = repository.description, !description.isEmpty {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            HStack {
                if let language = repository.language {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(languageColor(for: language))
                            .frame(width: 8, height: 8)
                        Text(language)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "star")
                            .font(.caption)
                        Text("\(repository.stargazersCount)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "tuningfork")
                            .font(.caption)
                        Text("\(repository.forksCount)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
    
    // MARK: - Language Color
    private func languageColor(for language: String) -> Color {
        switch language.lowercased() {
        case "swift": return .orange
        case "javascript": return .yellow
        case "typescript": return .blue
        case "python": return .green
        case "java": return .red
        case "kotlin": return .purple
        case "go": return .cyan
        case "rust": return .brown
        case "c++", "c": return .blue
        case "ruby": return .red
        default: return .gray
        }
    }
} 