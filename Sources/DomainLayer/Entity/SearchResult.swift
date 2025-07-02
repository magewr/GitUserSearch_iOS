import Foundation

public struct SearchResult: Codable, Equatable {
    public let totalCount: Int
    public let incompleteResults: Bool
    public let items: [GitUser]
    
    public init(
        totalCount: Int,
        incompleteResults: Bool,
        items: [GitUser]
    ) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
} 