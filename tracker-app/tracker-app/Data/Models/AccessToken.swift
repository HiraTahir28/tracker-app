import Foundation

class AuthToken: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: TimeInterval
    let dateCreated: Date

    var isExpired: Bool {
        Date().timeIntervalSince(dateCreated) > expiresIn
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        self.expiresIn = try container.decode(TimeInterval.self, forKey: .expiresIn)
        self.dateCreated = Date()
    }
}
