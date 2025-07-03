import Foundation
import DomainLayer

public enum GitHubEndpoint {
    case searchUsers(parameters: SearchParameters)
    case getUserDetail(username: String)
    case getUserRepositories(username: String)
}

extension GitHubEndpoint: Endpoint {
    public var baseURL: String {
        return "https://api.github.com"
    }
    
    public var path: String {
        switch self {
        case .searchUsers:
            return "/search/users"
        case .getUserDetail(let username):
            return "/users/\(username)"
        case .getUserRepositories(let username):
            return "/users/\(username)/repos"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .searchUsers, .getUserDetail, .getUserRepositories:
            return .GET
        }
    }
    
    public var queryItems: [URLQueryItem]? {
        switch self {
        case .searchUsers(let parameters):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "q", value: parameters.query),
                URLQueryItem(name: "page", value: String(parameters.page)),
                URLQueryItem(name: "per_page", value: String(parameters.perPage))
            ]
            
            if let sort = parameters.sort {
                items.append(URLQueryItem(name: "sort", value: sort.rawValue))
            }
            
            if let order = parameters.order {
                items.append(URLQueryItem(name: "order", value: order.rawValue))
            }
            
            return items
        case .getUserDetail:
            return nil
        case .getUserRepositories:
            return [
                URLQueryItem(name: "type", value: "public"),
                URLQueryItem(name: "sort", value: "updated"),
                URLQueryItem(name: "per_page", value: "30")
            ]
        }
    }
} 