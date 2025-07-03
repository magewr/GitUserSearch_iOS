import Foundation

public struct Repository: Identifiable, Codable, Equatable {
    public let id: Int
    public let nodeId: String
    public let name: String
    public let fullName: String
    public let isPrivate: Bool
    public let owner: RepositoryOwner
    public let htmlUrl: String
    public let description: String?
    public let fork: Bool
    public let url: String
    public let language: String?
    public let forksCount: Int
    public let stargazersCount: Int
    public let watchersCount: Int
    public let size: Int
    public let defaultBranch: String
    public let openIssuesCount: Int
    public let topics: [String]
    public let hasIssues: Bool
    public let hasProjects: Bool
    public let hasWiki: Bool
    public let hasPages: Bool
    public let hasDownloads: Bool
    public let archived: Bool
    public let disabled: Bool
    public let visibility: String
    public let pushedAt: String?
    public let createdAt: String
    public let updatedAt: String
    
    public init(
        id: Int,
        nodeId: String,
        name: String,
        fullName: String,
        isPrivate: Bool,
        owner: RepositoryOwner,
        htmlUrl: String,
        description: String?,
        fork: Bool,
        url: String,
        language: String?,
        forksCount: Int,
        stargazersCount: Int,
        watchersCount: Int,
        size: Int,
        defaultBranch: String,
        openIssuesCount: Int,
        topics: [String],
        hasIssues: Bool,
        hasProjects: Bool,
        hasWiki: Bool,
        hasPages: Bool,
        hasDownloads: Bool,
        archived: Bool,
        disabled: Bool,
        visibility: String,
        pushedAt: String?,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.nodeId = nodeId
        self.name = name
        self.fullName = fullName
        self.isPrivate = isPrivate
        self.owner = owner
        self.htmlUrl = htmlUrl
        self.description = description
        self.fork = fork
        self.url = url
        self.language = language
        self.forksCount = forksCount
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.size = size
        self.defaultBranch = defaultBranch
        self.openIssuesCount = openIssuesCount
        self.topics = topics
        self.hasIssues = hasIssues
        self.hasProjects = hasProjects
        self.hasWiki = hasWiki
        self.hasPages = hasPages
        self.hasDownloads = hasDownloads
        self.archived = archived
        self.disabled = disabled
        self.visibility = visibility
        self.pushedAt = pushedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
        case htmlUrl = "html_url"
        case description
        case fork
        case url
        case language
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case size
        case defaultBranch = "default_branch"
        case openIssuesCount = "open_issues_count"
        case topics
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasWiki = "has_wiki"
        case hasPages = "has_pages"
        case hasDownloads = "has_downloads"
        case archived
        case disabled
        case visibility
        case pushedAt = "pushed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct RepositoryOwner: Codable, Equatable {
    public let login: String
    public let id: Int
    public let nodeId: String
    public let avatarUrl: String
    public let gravatarId: String
    public let url: String
    public let htmlUrl: String
    public let type: String
    public let siteAdmin: Bool
    
    public init(
        login: String,
        id: Int,
        nodeId: String,
        avatarUrl: String,
        gravatarId: String,
        url: String,
        htmlUrl: String,
        type: String,
        siteAdmin: Bool
    ) {
        self.login = login
        self.id = id
        self.nodeId = nodeId
        self.avatarUrl = avatarUrl
        self.gravatarId = gravatarId
        self.url = url
        self.htmlUrl = htmlUrl
        self.type = type
        self.siteAdmin = siteAdmin
    }
    
    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlUrl = "html_url"
        case type
        case siteAdmin = "site_admin"
    }
} 