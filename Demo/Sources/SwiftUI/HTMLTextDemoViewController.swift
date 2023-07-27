import FinniversKit
import Foundation
import SwiftUI
import UIKit
import DemoKit

final class HTMLTextDemoViewController: UIViewController {
    let hostingController: UIHostingController<HTMLText>

    private var htmlView: HTMLText = HTMLText("") {
        didSet {
            hostingController.rootView = htmlView
        }
    }

    init() {
        self.hostingController = UIHostingController(rootView: htmlView)
        super.init(nibName: nil, bundle: nil)
        configure(forTweakAt: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

extension HTMLTextDemoViewController: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case `default`
        case linebreak
        case priceHighlight
        case strikethrough
        case mix
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .default:
            htmlView = HTMLText("This is <b>HTML</b>")
        case .linebreak:
            htmlView = HTMLText("This is <b>HTML</b><br>over two lines")
        case .priceHighlight:
            htmlView = HTMLText("Shipping costs <span style=\"color:tjt-price-highlight\">60 NOK</span>")
        case .strikethrough:
            htmlView = HTMLText("Old price is <del>80 NOK</del>")
        case .mix:
            htmlView = HTMLText("New price is <b>60 kr</b>, old price is <del>80 kr</del><br>Shipping is <span style=\"color:tjt-price-highlight\">60 kr</span>")
        }
    }
}
