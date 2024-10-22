import DemoKit
import FinniversKit
import SwiftUI
import Warp

struct InfoboxSwiftUIPresentationView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Warp.Spacing.spacing100) {
                Text("Style: .small(backgroundColor: .bgSecondary):")

                InfoboxSwiftUIView(
                    style: .small(backgroundColor: .backgroundInfoSubtle),
                    viewModel: InfoboxDefaultData()
                )
                .onPrimaryButtonTapped {
                    print("primary button tapped")
                }
                .onSecondaryButtonTapped {
                    print("secondary button tapped")
                }

                Divider()

                Text("Style: .normal(backgroundColor: .bgPrimary, primaryButtonIcon: UIImage(named: .webview):")
                InfoboxSwiftUIView(
                    style: .normal(
                        backgroundColor: .background,
                        primaryButtonIcon: UIImage(named: .webview)
                    ),
                    viewModel: InfoboxOpenBrowserData()
                )
                .onPrimaryButtonTapped {
                    print("primary button tapped")
                }
                .onSecondaryButtonTapped {
                    print("secondary button tapped")
                }

                Divider()

                Text("Style: .warning")
                InfoboxSwiftUIView(
                    style: .warning,
                    viewModel: InfoboxWarningData()
                )
                .onPrimaryButtonTapped {
                    print("primary button tapped")
                }
                .onSecondaryButtonTapped {
                    print("if you can read this...we have a problem :)")
                }

            }
            .font(from: .caption)
            .foregroundStyle(.secondary)
        }
        .padding()
    }
}

class InfoboxSwiftUIViewController: UIHostingController<InfoboxSwiftUIPresentationView>, Demoable {

    init() {
        super.init(rootView: InfoboxSwiftUIPresentationView())
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView = InfoboxSwiftUIPresentationView()
    }
}
