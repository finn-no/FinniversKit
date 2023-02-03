import FinniversKit
import Foundation
import SwiftUI
import UIKit

final class ResultSwiftUIDemoViewController: DemoViewController<UIView>, Tweakable {
    let hostingController: UIHostingController<ResultSwiftUIView>

    private var resultView: ResultSwiftUIView? {
        didSet {
            if let resultView {
                hostingController.rootView = resultView
            }
        }
    }

    private let errorRetryResultView: ResultSwiftUIView = {
        .init(
            image: Image(uiImage: UIImage(named: .dissatisfiedFace)),
            imageSize: 50,
            imageForegroundColor: .red,
            title: "Usjda",
            text: "Noe gikk galt",
            buttonTitle: "Prøv igjen",
            buttonAction: {}
        )
    }()

    private lazy var emptyResultView: ResultSwiftUIView = {
        .init(
            image: Image(uiImage: UIImage(named: .magnifyingGlass)), // magnifyingGlass
            title: "Klarte ikke finne annonsen",
            text: "Det kan se ut som annonsen du kikker etter har blitt slettet"
        )
    }()

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Error retry view", action: { [weak self] in
            guard let self = self else { return }
            self.resultView = self.errorRetryResultView
        }),
        TweakingOption(title: "Empty view", action: { [weak self] in
            guard let self = self else { return }
            self.resultView = self.emptyResultView
        })
    ]

    init() {
        self.resultView = errorRetryResultView
        self.hostingController = UIHostingController(rootView: errorRetryResultView)
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

