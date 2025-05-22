import Foundation
import SwiftData

@Model
public class GPSEntity {
    @Attribute(.unique)
    public var createdDateTime: String
    public var latitude: Double
    public var longitude: Double

    public init(createdDateTime: String, latitude: Double, longitude: Double) {
        self.createdDateTime = createdDateTime
        self.latitude = latitude
        self.longitude = longitude
    }
}
