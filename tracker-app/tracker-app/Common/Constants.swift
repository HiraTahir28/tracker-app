import Foundation

struct Constants {
    static let gpsRecordingInterval: TimeInterval = 10 // 10 seconds
    static let apiRetryInterval = 600 // 600 seconds = 10 minutes
    static let maxChunkSize = 100 // Max chunk size for sending GPS entries
}
