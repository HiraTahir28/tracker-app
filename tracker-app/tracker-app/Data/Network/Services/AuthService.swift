import Foundation

protocol AuthService {
    func getToken() async throws -> String
}

final class AuthServiceImpl: AuthService {
    private let networkService: NetworkService
    private var authToken: AuthToken?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        Task { self.authToken = try? await fetchToken() }
    }
    
    func getToken() async throws -> String {
        if let authToken, !authToken.isExpired {
            return authToken.accessToken
        } else {
            let token = try await fetchToken()
            self.authToken = token
            return token.accessToken
        }
    }
    
    private func fetchToken() async throws -> AuthToken {
        guard let url = URL(string: "https://demo-api.invendor.com/connect/token") else {
            throw NetworkError.badURL
        }
        
        let parameters = [
            "grant_type": "client_credentials",
            "client_id": "test-app",
            "client_secret": "388D45FA-B36B-4988-BA59-B187D329C207"
        ]
        
        let bodyString = urlEncodedString(from: parameters)
        let bodyData = bodyString.data(using: .utf8)
        
        let request = Request(
            url: url,
            method: .post,
            body: bodyData,
            headers: ["Content-Type": "application/x-www-form-urlencoded"]
        )
        let responseData = try await networkService.send(request: request)
        return try JSONDecoder().decode(AuthToken.self, from: responseData)
    }
}

func urlEncodedString(from parameters: [String: String]) -> String {
    parameters.map { key, value in
        let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(escapedKey)=\(escapedValue)"
    }
    .joined(separator: "&")
}
