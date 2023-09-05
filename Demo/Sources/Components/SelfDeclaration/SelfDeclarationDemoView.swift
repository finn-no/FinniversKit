//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit

class SelfDeclarationDemoView: UIView, Demoable {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInset = UIEdgeInsets(all: .spacingM)
        return scrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let selfDeclarationView = SelfDeclarationView(withAutoLayout: true)
        selfDeclarationView.configure(with: .example)

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(selfDeclarationView)
        selfDeclarationView.fillInSuperview()
    }
}

// MARK: - Private extensions

private extension SelfDeclarationViewModel {
    static let example: SelfDeclarationViewModel = {
        let viewModel = SelfDeclarationViewModel(items: [
            .init(
                question: "Kjente feil, mangler eller synlige skader?",
                answer: "Ja.",
                explanation: "Liten bulk på støtfanger foran"
            ),
            .init(
                question: "Er det gjort større reparasjoner?",
                answer: "Nei.",
                explanation: ""
            ),
            .init(
                question: "Har bilen heftelser/gjeld?",
                answer: "Nei.",
                explanation: ""
            )
        ])
        return viewModel
    }()
}
