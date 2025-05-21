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
        let gpsService = GPSServiceImpl(gpsDBService: gpsDBService)
        return TrackingViewModelImpl(gpsService: gpsService)
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
