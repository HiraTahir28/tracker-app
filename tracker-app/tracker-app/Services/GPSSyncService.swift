protocol GPSSyncService {
    func syncEntries() async
}

public final class GPSSyncServiceImpl: GPSSyncService {
    private let gpsNetworkService: GPSNetworkService
    private let dbService: GPSDBService
    
    init(
        gpsNetworkService: GPSNetworkService,
        dbService: GPSDBService
    ) {
        self.gpsNetworkService = gpsNetworkService
        self.dbService = dbService
    }
    
    public func syncEntries() async {
        do {
            try await syncChunkedEntries()
        } catch {
            try? await Task.sleep(for: .seconds(10 * 60))
            await syncEntries()
        }
    }
    
    private func syncChunkedEntries() async throws {
        let entries = try await dbService.fetchAll()
        let chunks = entries.chunked(by: 100)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for chunk in chunks {
                group.addTask { [weak self] in
                    guard let self else { return }
                    try await self.sendAndDelete(chunk)
                }
            }
            try await group.waitForAll()
        }
    }
    
    private func sendAndDelete(_ chunk: [GPSEntity]) async throws {
        try await gpsNetworkService.send(entieries: chunk.map { $0.toModel() })
        try await dbService.delete(enteries: chunk)
    }
}
