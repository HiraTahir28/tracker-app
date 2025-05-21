extension GPSEntity {
    func toModel() -> GPSEntryModel {
        return GPSEntryModel(
            createdDateTime: createdDateTime,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    static func fromModel(_ model: GPSEntryModel) -> GPSEntity {
        return GPSEntity(
            createdDateTime: model.createdDateTime,
            latitude: model.latitude,
            longitude: model.longitude
        )
    }
}
