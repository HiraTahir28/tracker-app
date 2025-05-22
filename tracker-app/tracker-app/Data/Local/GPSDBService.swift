import Foundation
import SwiftData

protocol GPSDBService: Actor {
    func save(entry: GPSEntryModel) async throws
    func fetchAll() async throws -> [GPSEntity]
    func delete(enteries: [GPSEntity]) async throws
    func deleteAll() async throws
}

@ModelActor
actor GPSDBServiceImpl: GPSDBService {
    func save(entry: GPSEntryModel) async throws {
        let entity = GPSEntity.fromModel(entry)
        modelContext.insert(entity)
        try modelContext.save()
    }
    
    func fetchAll() async throws -> [GPSEntity] {
        let fetchDescriptor = FetchDescriptor<GPSEntity>()
        return try modelContext.fetch(fetchDescriptor)
    }
    
    func delete(enteries: [GPSEntity]) async throws {
        for entry in enteries {
            modelContext.delete(entry)
        }
        try modelContext.save()
    }
    
    func deleteAll() async throws {
        let entries = try await fetchAll()
        for entry in entries {
            modelContext.delete(entry)
        }
        try modelContext.save()
    }
}
