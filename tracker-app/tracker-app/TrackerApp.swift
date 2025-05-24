import SwiftUI
import SwiftData

@main
struct TrackerApp: App {
    @State private var viewModel: TrackingViewModelImpl?
    
    var body: some Scene {
        WindowGroup {
            buildTrackingView()
                .onAppear {
                    viewModel = createTrackingViewModel()
                }
        }
    }
    
    @ViewBuilder
    private func buildTrackingView() -> some View {
        if let viewModel = viewModel {
            TrackingView(viewModel: viewModel)
        } else {
            ProgressView("Loading...")
        }
    }
}

private extension TrackerApp {
    func createTrackingViewModel() -> TrackingViewModelImpl {
        let modelContainer = createModelContainer()
        let gpsDBService = GPSDBServiceImpl(modelContainer: modelContainer)
        let networkService = NetworkService()
        let gpsService = GPSServiceImpl(gpsDBService: gpsDBService)
        let authService = AuthServiceImpl(networkService: networkService)
        let gpsNetworkService = GPSNetworkServiceImpl(
            networkService: networkService,
            authService: authService
        )
        let gpsSyncService = GPSSyncServiceImpl(
            gpsNetworkService: gpsNetworkService,
            dbService: gpsDBService
        )
        
        return TrackingViewModelImpl(
            gpsService: gpsService,
            gpsSyncService: gpsSyncService
        )
    }
    
    func createModelContainer() -> ModelContainer {
        do {
            return try ModelContainer(
                for: GPSEntity.self
            )
        } catch {
            fatalError("Failed to setup model container: \(error)")
        }
    }
}
