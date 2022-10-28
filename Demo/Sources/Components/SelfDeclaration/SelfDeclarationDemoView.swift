//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import SwiftUI

class SelfDeclarationDemoView: UIView {

    private lazy var scrollView = {
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
        let selfDeclarationVC = UIHostingController(rootView: SelfDeclarationView(vm: .example))

        guard let selfDeclarationView = selfDeclarationVC.view else { return }
        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(selfDeclarationView)
        selfDeclarationView.fillInSuperview()
    }
}

// MARK: - Private extensions

private extension SelfDeclarationViewModel {
    static let example: SelfDeclarationViewModel = {
        let vm = SelfDeclarationViewModel(items: [
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
        return vm
    }()
}
