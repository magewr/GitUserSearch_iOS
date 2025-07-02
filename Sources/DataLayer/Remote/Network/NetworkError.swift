import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case httpError(statusCode: Int)
    case networkUnavailable
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .noData:
            return "데이터를 받을 수 없습니다."
        case .decodingError(let error):
            return "데이터 파싱 실패: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "HTTP 오류: \(statusCode)"
        case .networkUnavailable:
            return "네트워크에 연결할 수 없습니다."
        case .unknown(let error):
            return "알 수 없는 오류: \(error.localizedDescription)"
        }
    }
} 