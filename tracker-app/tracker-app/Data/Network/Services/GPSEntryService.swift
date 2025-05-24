import Foundation

protocol GPSNetworkService {
    func send(entieries: [GPSEntryModel]) async throws
}

final class GPSNetworkServiceImpl: GPSNetworkService {
    private let baseURL = URL(string: "https://demo-api.invendor.com/api/GPSEntries")
    private let networkService: NetworkService
    private let authService: AuthService
    
    init(networkService: NetworkService, authService: AuthService) {
        self.networkService = networkService
        self.authService = authService
    }
    
    public func send(entieries: [GPSEntryModel]) async throws {
        guard let baseURL else {
            throw NetworkError.badURL
        }
        
        let url = baseURL.appendingPathComponent("bulk")
        let token = try await authService.getToken()
        let request = Request(
            url: url,
            method: .post,
            body: try JSONEncoder().encode(entieries),
            headers: ["Content-Type": "application/json"],
            token: token
        )
        try await networkService.send(request: request)
    }
}
