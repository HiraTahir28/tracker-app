import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Request {
    let url: URL
    let method: HTTPMethod
    var queryParameters: [String: String]? = nil
    var body: Data? = nil
    var headers: [String: String] = [:]
    var token: String? = nil
    
    func build() throws -> URLRequest {
        let url = try buildUrl(url, queryParameters: queryParameters)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if headers["Content-Type"] == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

private extension Request {
    func buildUrl(_ url: URL, queryParameters: [String: String]?) throws -> URL {
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
}
