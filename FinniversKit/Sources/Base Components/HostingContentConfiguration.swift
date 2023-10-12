import SwiftUI
import UIKit

/// A substitute for UIHostingConfiguration for use on iOS < 16.
///
/// https://medium.com/justeattakeaway-tech/using-swiftui-inside-an-ancient-uitableview-or-uicollectionview-bb8defb6304
///
/// https://github.com/woxtu/UIHostingConfigurationBackport
///
public struct HostingContentConfiguration<Content>: UIContentConfiguration where Content: View {
    public let hostingController: UIHostingController<Content>

    public init(@ViewBuilder content: () -> Content) {
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.backgroundColor = .clear
        self.hostingController = hostingController
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
    var configuration: UIContentConfiguration

    private var hostingController: UIHostingController<Content> {
        (configuration as! HostingContentConfiguration<Content>).hostingController
    }

    init(_ configuration: HostingContentConfiguration<Content>) {
        self.configuration = configuration
        super.init(frame: .zero)

        guard let hostingView = hostingController.view else { return }
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        if superview == nil {
            hostingController.willMove(toParent: nil)
            hostingController.removeFromParent()
        } else if let parentVC = parentViewController {
            parentVC.addChild(hostingController)
            hostingController.didMove(toParent: parentVC)
        }
    }
}

private extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
