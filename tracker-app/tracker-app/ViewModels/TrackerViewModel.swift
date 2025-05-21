import Foundation

enum TrackingEvent {
    case start
    case stop
}

protocol TrackingViewModelProtocol: ObservableObject {
    func send(_ event: TrackingEvent)

    var isTracking: Bool { get }
}

public final class TrackingViewModel: TrackingViewModelProtocol {
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
