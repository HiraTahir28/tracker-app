import Foundation
import CoreLocation
import SwiftData

public protocol GPSService: AnyObject {
    func startTracking()
    func stopTracking()
}

final class GPSServiceImpl: NSObject, GPSService {
    private let gpsDBService: GPSDBService
    private let locationManager = CLLocationManager()
    
    private var timer: Timer?

    init(gpsDBService: GPSDBService) {
        self.gpsDBService = gpsDBService

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            print("Location permission not granted yet!")
            locationManager.requestWhenInUseAuthorization()
            return
        }

        locationManager.startUpdatingLocation()

        if let location = locationManager.location {
            createGPSEntry(of: location)
        }

        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let self = self,
                  let location = self.locationManager.location else { return }

            createGPSEntry(of: location)
        }
    }
    
    func createGPSEntry(of location: CLLocation) {
        let gpsEntry = GPSEntryModel(
            createdDateTime: ISO8601DateFormatter().string(from: Date()),
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        print("Tracked Location -> \(gpsEntry)")
      
        Task {
            do {
                try await gpsDBService.save(entry: gpsEntry)
            } catch {
                print("Failed to save GPS entry: \(error)")
            }
        }
    }
    
    func stopTracking() {
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
    }
}

extension GPSServiceImpl: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        default:
            break
        }
    }
}
