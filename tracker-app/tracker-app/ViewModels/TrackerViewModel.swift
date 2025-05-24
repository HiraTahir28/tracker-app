import Foundation

enum TrackingEvent {
    case start
    case stop
}

protocol TrackingViewModel: ObservableObject {
    var isTracking: Bool { get }
    
    func send(_ event: TrackingEvent) async
}

public final class TrackingViewModelImpl: TrackingViewModel {
    @Published var isTracking: Bool = false
    
    private let gpsService: GPSService
    private let gpsSyncService: GPSSyncService
    
    init(
        gpsService: GPSService,
        gpsSyncService: GPSSyncService
    ) {
        self.gpsService = gpsService
        self.gpsSyncService = gpsSyncService
        
        Task {
            await gpsSyncService.syncEntries()
        }
    }
    
    @MainActor
    func send(_ event: TrackingEvent) async {
        switch event {
        case .start:
            gpsService.startTracking()
            isTracking = true
            
        case .stop:
            gpsService.stopTracking()
            isTracking = false
            
            await gpsSyncService.syncEntries()
        }
    }
}
