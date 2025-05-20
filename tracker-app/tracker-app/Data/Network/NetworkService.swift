import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class NetworkService {
    private let session: URLSession
    private let requestBuilder: Request
    
    init(requestBuilder: Request, session: URLSession = .shared) {
        self.requestBuilder = requestBuilder
        self.session = session
    }
    
    func send(
        urlPath: URL,
        method: HTTPMethod,
        queryParameters: [String: String]? = nil,
        body: Data? = nil,
        headers: [String: String] = [:]
    ) async throws -> Data {
        let url = try requestBuilder.buildURL(url: urlPath, queryParameters: queryParameters)
        let urlRequest = requestBuilder.buildRequest(url: url, method: method, body: body, headers: headers)
        
        let (data, response) = try await session.data(for: urlRequest)
        try validate(response: response)
        return data
    }
    
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }
}

