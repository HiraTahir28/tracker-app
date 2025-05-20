import Foundation

final class Request {
    private let token: String?
    
    init(token: String? = nil) {
        self.token = token
    }
    
    func buildURL(url: URL, queryParameters: [String: String]?) throws -> URL {
        guard let queries = queryParameters, !queries.isEmpty else {
            return url
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.badURL
        }
        components.queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let finalURL = components.url else {
            throw NetworkError.badURL
        }
        return finalURL
    }
    
    func buildRequest(url: URL, method: HTTPMethod, body: Data?, headers: [String: String]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

