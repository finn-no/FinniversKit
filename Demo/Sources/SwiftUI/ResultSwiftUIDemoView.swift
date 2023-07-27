import FinniversKit
import Foundation
import SwiftUI
import UIKit
import DemoKit

final class ResultSwiftUIDemoViewController: UIViewController {
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
            image: Image(uiImage: UIImage(named: .magnifyingGlass)),
            title: "Klarte ikke finne annonsen",
            text: "Det kan se ut som annonsen du kikker etter har blitt slettet"
        )
    }()

    init() {
        self.resultView = errorRetryResultView
        self.hostingController = UIHostingController(rootView: errorRetryResultView)
        super.init(nibName: nil, bundle: nil)
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
        hostingController.didMove(toParent: self    )
    }
}

extension ResultSwiftUIDemoViewController: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case errorRetryView
        case emptyView
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .errorRetryView:
            resultView = errorRetryResultView
        case .emptyView:
            resultView = emptyResultView
        }
    }
}
