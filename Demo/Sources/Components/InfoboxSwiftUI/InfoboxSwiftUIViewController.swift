import DemoKit
import FinniversKit
import SwiftUI

struct InfoboxSwiftUIPresentationView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: .spacingS) {
                Text("Style: .small(backgroundColor: .bgSecondary):")

                InfoboxSwiftUIView(
                    style: .small(backgroundColor: .bgSecondary),
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
                        backgroundColor: .bgPrimary,
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
            .finnFont(.caption)
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
