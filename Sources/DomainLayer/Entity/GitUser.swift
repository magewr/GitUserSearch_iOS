import Foundation

public struct GitUser: Identifiable, Codable, Equatable {
    public let id: Int
    public let login: String
    public let nodeId: String
    public let avatarUrl: String
    public let gravatarId: String
    public let url: String
    public let htmlUrl: String
    public let followersUrl: String
    public let subscriptionsUrl: String
    public let organizationsUrl: String
    public let reposUrl: String
    public let receivedEventsUrl: String
    public let type: String
    public let score: Double
    
    public init(
        id: Int,
        login: String,
        nodeId: String,
        avatarUrl: String,
        gravatarId: String,
        url: String,
        htmlUrl: String,
        followersUrl: String,
        subscriptionsUrl: String,
        organizationsUrl: String,
        reposUrl: String,
        receivedEventsUrl: String,
        type: String,
        score: Double
    ) {
        self.id = id
        self.login = login
        self.nodeId = nodeId
        self.avatarUrl = avatarUrl
        self.gravatarId = gravatarId
        self.url = url
        self.htmlUrl = htmlUrl
        self.followersUrl = followersUrl
        self.subscriptionsUrl = subscriptionsUrl
        self.organizationsUrl = organizationsUrl
        self.reposUrl = reposUrl
        self.receivedEventsUrl = receivedEventsUrl
        self.type = type
        self.score = score
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case receivedEventsUrl = "received_events_url"
        case type
        case score
    }
} 