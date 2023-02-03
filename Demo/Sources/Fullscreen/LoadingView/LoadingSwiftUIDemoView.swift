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
    @SwiftUI.State private var loadingViewModel: LoadingSwiftUIViewModel?
    @SwiftUI.State private var showDelay: Double?
    @SwiftUI.State private var hideDelay: Double?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacingS) {
                Text(loadingViewModel == nil ? " " : "Selected view model")
                LoadingDemoRow(title: "Simple show", description: "(shows immediately, hides after a second)") {
                    showDelay = nil
                    hideDelay = 1.0
                    loadingViewModel = .init(mode: .fullscreen)
                }
                LoadingDemoRow(title: "Simple show", description: "(shows after 0.5s, hides after a second)") {
                    showDelay = 0.5
                    hideDelay = 1.0
                    loadingViewModel = .init(mode: .fullscreen)
                }
                LoadingDemoRow(title: "Show with message", description: "shows immediately, hides after a second") {
                    showDelay = nil
                    hideDelay = 1.0
                    loadingViewModel = .init(mode: .fullscreen, message: "Hi there!")
                }
                LoadingDemoRow(title: "Show with message", description: "shows after 0.5s, hides after a second") {
                    showDelay = 0.5
                    hideDelay = 1.0
                    loadingViewModel = .init(mode: .fullscreen, message: "Hi there!")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .loadingOverlay(viewModel: $loadingViewModel, showAfter: showDelay, hideAfter: hideDelay)
    }

    /*
    private lazy var options: [Option] = {
        var options = [Option]()

        options.append(Option(title: "Show success", description: "shows after 0.5s, hides after a second", action: {
            LoadingView.showSuccess(displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show success", description: "shows immediately, hides after a second", action: {
            LoadingView.showSuccess(afterDelay: 0, displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show success with message", description: "shows after 0.5s, hides after a second", action: {
            LoadingView.showSuccess(withMessage: "Hi there!", displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show success with message", description: "shows immediately, hides after a second", action: {
            LoadingView.showSuccess(withMessage: "Hi there!", afterDelay: 0, displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Full: Shows w/ message, Success, Hides", description: "shows after 0.5s, hides after 2s", action: {
            LoadingView.show(withMessage: "Hi there!", displayType: self.currentDisplayType)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.showSuccess(withMessage: "It worked!", displayType: self.currentDisplayType)
                LoadingView.hide(afterDelay: 1.0)
            })
        }))

        options.append(Option(title: "Full: Show w/ message, Success, Hides", description: "shows immediately, hides after 2s", action: {
            LoadingView.show(withMessage: "Hi there!", afterDelay: 0, displayType: self.currentDisplayType)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.showSuccess(withMessage: "It worked!", afterDelay: 0, displayType: self.currentDisplayType)
                LoadingView.hide(afterDelay: 1.0)
            })
        }))

        options.append(Option(title: "throttling: show and hide right after", description: "should not be visible at all", action: {
            LoadingView.show(withMessage: "Hi there!", displayType: self.currentDisplayType)
            LoadingView.hide()
        }))

        options.append(Option(title: "Racy scheduling", description: "Show only show the success-view", action: {
            LoadingView.show(withMessage: "Should not be visible", afterDelay: 0.2, displayType: self.currentDisplayType)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                LoadingView.showSuccess(withMessage: "Success", afterDelay: 0, displayType: self.currentDisplayType)
                LoadingView.hide(afterDelay: 0.5)
            })
        }))

        return options
    }()
*/
}

struct LoadingSwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSwiftUIDemoView()
    }
}
