import DemoKit
import FinniversKit
import SwiftUI

struct InfoboxSwiftUIPresentationView: View {
    let models: [InfoboxSwiftUIViewModel]
    var body: some View {
        ScrollView {
            VStack {
                ForEach(models) { model in
                    InfoboxSwiftUIView(viewModel: model)
                }
            }
            .padding()
        }
    }
}

class InfoboxSwiftUIViewController: UIHostingController<InfoboxSwiftUIPresentationView>, Demoable {

    init() {
        super.init(rootView: InfoboxSwiftUIPresentationView(models: []))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let models: [InfoboxSwiftUIViewModel] = [
            .init(
                informationType: .critical,
                title: "Critical",
                detail: "And some text"
            ),
            .init(
                informationType: .information,
                title: "Information",
                detail: "And some text"
            ),
            .init(
                informationType: .information,
                title: "Information",
                detail: "And some text, and a link",
                linkInteraction: .init(title: "Link here", onTapped: { print("You tapped a link") })
            ),
            .init(
                informationType: .success,
                title: "Success",
                detail: "And some text"
            ),
            .init(
                informationType: .warning,
                title: "Warning",
                detail: "And some text"
            ),
            .init(
                informationType: .warning,
                title: "Warning",
                detail: "And some text, and a link and a primary button",
                linkInteraction: .init(title: "Link here", onTapped: { print("You tapped a link") }),
                primaryButtonInteraction: .init(title: "Button", onTapped: { print("You tapped a button") })
            ),
            .init(
                informationType: .warning,
                title: "Warning",
                detail: "And some text, and a link and a primary and secondary button",
                linkInteraction: .init(title: "Link here", onTapped: { print("You tapped a link") }),
                primaryButtonInteraction: .init(title: "Button 1", onTapped: { print("You tapped button 1") }),
                secondaryButtonInteraction: .init(title: "Button 2", onTapped: { print("You tapped button 2") })
            ),
            .init(
                informationType: .custom(
                    backgroundColor: .red,
                    borderColor: .green,
                    sidebarColor: .yellow,
                    iconImage: nil
                ),
                title: "Custom",
                detail: "With pretty colors!"
            )
        ]
        rootView = InfoboxSwiftUIPresentationView(models: models)
    }
}
