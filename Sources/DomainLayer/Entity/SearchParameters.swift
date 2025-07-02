import Foundation

public struct SearchParameters: Equatable {
    public let query: String
    public let sort: SortType?
    public let order: OrderType?
    public let page: Int
    public let perPage: Int
    
    public init(
        query: String,
        sort: SortType? = nil,
        order: OrderType? = nil,
        page: Int = 1,
        perPage: Int = 30
    ) {
        self.query = query
        self.sort = sort
        self.order = order
        self.page = page
        self.perPage = perPage
    }
}

public enum SortType: String, CaseIterable {
    case followers
    case repositories
    case joined
    
    public var displayName: String {
        switch self {
        case .followers: return "팔로워"
        case .repositories: return "저장소"
        case .joined: return "가입일"
        }
    }
}

public enum OrderType: String, CaseIterable {
    case asc
    case desc
    
    public var displayName: String {
        switch self {
        case .asc: return "오름차순"
        case .desc: return "내림차순"
        }
    }
} 