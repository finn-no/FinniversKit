import FinniversKit
import Foundation
import SwiftUI
import UIKit

final class HTMLTextDemoViewController: DemoViewController<UIView>, Tweakable {
    let hostingController: UIHostingController<HTMLText>

    private var htmlView: HTMLText = HTMLText("") {
        didSet {
            hostingController.rootView = htmlView
        }
    }

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Default", action: { [weak self] in
            guard let self = self else { return }
            self.htmlView = HTMLText("This is <b>HTML</b>")
        }),
        TweakingOption(title: "Linebreak", action: { [weak self] in
            guard let self = self else { return }
            self.htmlView = HTMLText("This is <b>HTML</b><br>over two lines")
        }),
        TweakingOption(title: "Price highlight", action: { [weak self] in
            guard let self = self else { return }
            self.htmlView = HTMLText("Shipping costs <span style=\"color:tjt-price-highlight\">60 NOK</span>")
        }),
        TweakingOption(title: "Strikethrough", action: { [weak self] in
            guard let self = self else { return }
            self.htmlView = HTMLText("Old price is <del>80 NOK</del>")
        }),
        TweakingOption(title: "Mix", action: { [weak self] in
            guard let self = self else { return }
            self.htmlView = HTMLText("New price is <b>60 kr</b>, old price is <del>80 kr</del><br>Shipping is <span style=\"color:tjt-price-highlight\">60 kr</span>")
        }),
    ]

    init() {
        self.htmlView = HTMLText("This is <b>HTML</b>")
        self.hostingController = UIHostingController(rootView: htmlView)
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let childViewController = childViewController else {
            return
        }

        childViewController.addChild(hostingController)
        hostingController.view.frame = childViewController.view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: childViewController)
    }
}
