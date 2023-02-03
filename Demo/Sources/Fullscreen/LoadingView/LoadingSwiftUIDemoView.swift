import FinniversKit
import SwiftUI

private struct LoadingDemoRow: View {
    let title: String
    let description: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Text(title)
                Text(description)
            }
        }
    }
}

struct LoadingSwiftUIDemoView: View {
    @SwiftUI.State private var isActive: Bool = false
    @SwiftUI.State private var message: String?
    @SwiftUI.State private var showSuccess: Bool = false
    @SwiftUI.State private var showDelay: Double?
    @SwiftUI.State private var hideDelay: Double?
    @SwiftUI.State private var isFullscreen: Bool = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacingM) {
                Text(isActive ? "Active" : "Not active")

                Toggle(isOn: $isFullscreen) {
                    Text(isFullscreen ? "Fullscreen" : "Box")
                }

                Group {
                    LoadingDemoRow(title: "Simple show", description: "(shows immediately, hides after a second)") {
                        message = nil
                        showSuccess = false
                        showDelay = nil
                        hideDelay = 1.0
                        isActive = true
                    }
                    LoadingDemoRow(title: "Simple show", description: "(shows after 0.5s, hides after a second)") {
                        message = nil
                        showSuccess = false
                        showDelay = 0.5
                        hideDelay = 1.0
                        isActive = true
                    }
                    LoadingDemoRow(title: "Show with message", description: "shows immediately, hides after a second") {
                        message = "Hi there!"
                        showSuccess = false
                        showDelay = nil
                        hideDelay = 1.0
                        isActive = true
                    }
                    LoadingDemoRow(title: "Show with message", description: "shows after 0.5s, hides after a second") {
                        message = "Hi there!"
                        showSuccess = false
                        showDelay = 0.5
                        hideDelay = 1.0
                        isActive = true
                    }
                }
                Group {
                    LoadingDemoRow(title: "Show success", description: "shows immediately, hides after a second") {
                        message = nil
                        showSuccess = true
                        showDelay = nil
                        hideDelay = 1.0
                        isActive = true
                    }
                    LoadingDemoRow(title: "Show success", description: "shows after 0.5s, hides after a second") {
                        message = nil
                        showSuccess = true
                        showDelay = 0.5
                        hideDelay = 1.0
                        isActive = true
                    }
                    LoadingDemoRow(title: "Show success with message", description: "shows immediately, hides after a second") {
                        message = "Hi there!"
                        showSuccess = true
                        showDelay = nil
                        hideDelay = 1.0
                        isActive = true
                    }
                    LoadingDemoRow(title: "Show success with message", description: "shows after 0.5s, hides after a second") {
                        message = "Hi there!"
                        showSuccess = true
                        showDelay = 0.5
                        hideDelay = 1.0
                        isActive = true
                    }
                }
                Group {
                    LoadingDemoRow(title: "Show with message, Success, Hides", description: "Shows immediately, hides after 2s") {
                        message = "Hi there!"
                        showSuccess = false
                        showDelay = nil
                        hideDelay = 2.0
                        isActive = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            message = "It worked!"
                            showSuccess = true
                        }
                    }
                    LoadingDemoRow(title: "Show with message, Success, Hides", description: "Shows after 0.5s, hides after 2s") {
                        message = "Hi there!"
                        showSuccess = false
                        showDelay = 0.5
                        hideDelay = 2.0
                        isActive = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            message = "It worked!"
                            showSuccess = true
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .loadingOverlay(isActive: $isActive, displayMode: isFullscreen ? .fullscreen : .boxed, message: message, showSuccess: showSuccess, showAfter: showDelay, hideAfter: hideDelay)
    }
}

struct LoadingSwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSwiftUIDemoView()
    }
}
