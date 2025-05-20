import SwiftUI

struct TrackingView: View {
    @StateObject private var viewModel = TrackingViewModel()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                trackingButton(
                    title: "Start Tracking",
                    color: .green,
                    isEnabled: !viewModel.isTracking,
                    action: { viewModel.send(.start) }
                )
                
                trackingButton(
                    title: "Stop Tracking",
                    color: .red,
                    isEnabled: viewModel.isTracking,
                    action: { viewModel.send(.stop) }
                )
            }
            .padding()
            .frame(maxWidth: 300)
        }
    }
    
    @ViewBuilder
    private func trackingButton(
        title: String,
        color: Color,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(isEnabled ? .heavy : .regular)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color.opacity(isEnabled ? 1.0 : 0.5))
                .cornerRadius(10)
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    TrackingView()
}
