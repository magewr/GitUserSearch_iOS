import Foundation

public protocol NetworkClientProtocol {
    func request<T: Codable>(_ endpoint: Endpoint) async throws -> T
}

public class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        
        // GitHub API 날짜 형식에 맞게 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    public func request<T: Codable>(_ endpoint: Endpoint) async throws -> T {
        // URL 구성
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        
        do {
            // 네트워크 요청 수행
            let (data, response) = try await session.data(for: request)
            
            // HTTP 응답 상태 코드 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(URLError(.badServerResponse))
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }
            
            // 데이터 디코딩
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    throw NetworkError.networkUnavailable
                default:
                    throw NetworkError.unknown(urlError)
                }
            } else {
                throw NetworkError.unknown(error)
            }
        }
    }
}

// MARK: - HTTP Method
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
} 