import SwiftUI
import UIKit

/// A substitute for UIHostingConfiguration for use on iOS < 16.
/// https://medium.com/justeattakeaway-tech/using-swiftui-inside-an-ancient-uitableview-or-uicollectionview-bb8defb6304
public struct HostingContentConfiguration<Content>: UIContentConfiguration where Content: View {
    fileprivate let hostingController: UIHostingController<Content>

    public init(@ViewBuilder content: () -> Content) {
        hostingController = UIHostingController(rootView: content())
    }

    public init(hostingController: UIHostingController<Content>) {
        self.hostingController = hostingController
    }

    public func makeContentView() -> UIView & UIContentView {
        ContentView<Content>(self)
    }

    public func updated(for state: UIConfigurationState) -> HostingContentConfiguration<Content> {
        self
    }
}

private final class ContentView<Content>: UIView, UIContentView where Content: View {
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration)
        }
    }

    private weak var hostingController: UIHostingController<Content>?

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        hostingController?.removeFromParent()
    }

    func configure(_ configuration: UIContentConfiguration) {
        guard
            let configuration = configuration as? HostingContentConfiguration<Content>,
            let parent = findViewController()
        else { return }

        let hostingController = configuration.hostingController

        guard
            let swiftUICellView = hostingController.view,
            subviews.isEmpty
        else {
            hostingController.view.invalidateIntrinsicContentSize()
            return
        }

        hostingController.view.backgroundColor = .clear

        parent.addChild(hostingController)
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: swiftUICellView.leadingAnchor),
            trailingAnchor.constraint(equalTo: swiftUICellView.trailingAnchor),
            topAnchor.constraint(equalTo: swiftUICellView.topAnchor),
            bottomAnchor.constraint(equalTo: swiftUICellView.bottomAnchor)
        ])
        hostingController.didMove(toParent: parent)
        self.hostingController = hostingController
    }
}

private extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.findViewController()
        }

        return nil
    }
}
