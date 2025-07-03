import Foundation

public struct UserDetail: Identifiable, Codable, Equatable {
    public let id: Int
    public let login: String
    public let nodeId: String
    public let avatarUrl: String
    public let gravatarId: String
    public let url: String
    public let htmlUrl: String
    public let followersUrl: String
    public let followingUrl: String
    public let gistsUrl: String
    public let starredUrl: String
    public let subscriptionsUrl: String
    public let organizationsUrl: String
    public let reposUrl: String
    public let eventsUrl: String
    public let receivedEventsUrl: String
    public let type: String
    public let siteAdmin: Bool
    public let name: String?
    public let company: String?
    public let blog: String?
    public let location: String?
    public let email: String?
    public let hireable: Bool?
    public let bio: String?
    public let twitterUsername: String?
    public let publicRepos: Int
    public let publicGists: Int
    public let followers: Int
    public let following: Int
    public let createdAt: String
    public let updatedAt: String
    
    public init(
        id: Int,
        login: String,
        nodeId: String,
        avatarUrl: String,
        gravatarId: String,
        url: String,
        htmlUrl: String,
        followersUrl: String,
        followingUrl: String,
        gistsUrl: String,
        starredUrl: String,
        subscriptionsUrl: String,
        organizationsUrl: String,
        reposUrl: String,
        eventsUrl: String,
        receivedEventsUrl: String,
        type: String,
        siteAdmin: Bool,
        name: String?,
        company: String?,
        blog: String?,
        location: String?,
        email: String?,
        hireable: Bool?,
        bio: String?,
        twitterUsername: String?,
        publicRepos: Int,
        publicGists: Int,
        followers: Int,
        following: Int,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.login = login
        self.nodeId = nodeId
        self.avatarUrl = avatarUrl
        self.gravatarId = gravatarId
        self.url = url
        self.htmlUrl = htmlUrl
        self.followersUrl = followersUrl
        self.followingUrl = followingUrl
        self.gistsUrl = gistsUrl
        self.starredUrl = starredUrl
        self.subscriptionsUrl = subscriptionsUrl
        self.organizationsUrl = organizationsUrl
        self.reposUrl = reposUrl
        self.eventsUrl = eventsUrl
        self.receivedEventsUrl = receivedEventsUrl
        self.type = type
        self.siteAdmin = siteAdmin
        self.name = name
        self.company = company
        self.blog = blog
        self.location = location
        self.email = email
        self.hireable = hireable
        self.bio = bio
        self.twitterUsername = twitterUsername
        self.publicRepos = publicRepos
        self.publicGists = publicGists
        self.followers = followers
        self.following = following
        self.createdAt = createdAt
        self.updatedAt = updatedAt
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
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case name
        case company
        case blog
        case location
        case email
        case hireable
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
} 