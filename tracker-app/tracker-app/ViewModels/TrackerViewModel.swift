import Foundation

enum TrackingEvent {
    case start
    case stop
}

protocol TrackingViewModel: ObservableObject {
    var isTracking: Bool { get }
    
    func send(_ event: TrackingEvent)
}

public final class TrackingViewModelImpl: TrackingViewModel {
    @Published var isTracking = false
    private let gpsService: GPSService
    
    init(gpsService: GPSService) {
        self.gpsService = gpsService
    }
    
    func send(_ event: TrackingEvent) {
        switch event {
        case .start:
            print("Start Tracking tapped")
            gpsService.startTracking()
            isTracking = true
            
        case .stop:
            print("Stop Tracking tapped")
            gpsService.stopTracking()
            isTracking = false
        }
    }
}
