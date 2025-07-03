import SwiftUI
import DomainLayer

public struct UserRowView: View {
    let user: GitUser
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    public init(
        user: GitUser,
        isFavorite: Bool,
        onFavoriteToggle: @escaping () -> Void
    ) {
        self.user = user
        self.isFavorite = isFavorite
        self.onFavoriteToggle = onFavoriteToggle
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // 사용자 아바타
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // 사용자 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(user.login)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !user.htmlUrl.isEmpty {
                    Text(user.htmlUrl)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // 우측 버튼들
            HStack(spacing: 12) {
                // 즐겨찾기 버튼
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
                
                // 화살표 아이콘
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    let sampleUser = GitUser(
        id: 1,
        login: "octocat",
        nodeId: "MDQ6VXNlcjE=",
        avatarUrl: "https://github.com/images/error/octocat_happy.gif",
        gravatarId: "",
        url: "https://api.github.com/users/octocat",
        htmlUrl: "https://github.com/octocat",
        followersUrl: "https://api.github.com/users/octocat/followers",
        subscriptionsUrl: "https://api.github.com/users/octocat/subscriptions",
        organizationsUrl: "https://api.github.com/users/octocat/orgs",
        reposUrl: "https://api.github.com/users/octocat/repos",
        receivedEventsUrl: "https://api.github.com/users/octocat/received_events",
        type: "User",
        score: 98.5
    )
    
    return UserRowView(
        user: sampleUser,
        isFavorite: false,
        onFavoriteToggle: {}
    )
} 