import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case invalidResponse(statusCode: Int)
    case unknown
    case underlying(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .invalidResponse(let statusCode):
            return "Server returned status code \(statusCode)."
        case .unknown:
            return "An unknown error occurred."
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}
