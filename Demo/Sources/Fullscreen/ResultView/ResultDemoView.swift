//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit

class ResultDemoView: UIView {

    private lazy var resultView = ResultView(withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        configure(forTweakAt: 0)
        addSubview(resultView)
        resultView.fillInSuperview()
    }
}

extension ResultDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case allElements
        case coloredTitle
        case coloredTitleMultipleLines
        case justTitle
        case success
        case error
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .allElements:
            resultView.configure(
                title: "Klarte ikke å finne annonsen",
                description: "Det kan se ut som at annonsen du\nkikker etter er blitt slettet.",
                icon: UIImage(named: .magnifyingGlass).withRenderingMode(.alwaysTemplate)
            )
        case .coloredTitle:
            resultView.configure(title: "Prøv igjen", titleColor: .textAction)
        case .coloredTitleMultipleLines:
            resultView.configure(
                title: "Denne annonsetypen støttesikke i appen, trykk for å åpne i Safari",
                titleColor: .textAction
            )
        case .justTitle:
            resultView.configure(
                title: "Du mangler nettforbindelse"
            )
        case .success:
            resultView.configure(
                title: "Hurra!",
                description: "En bekreftelse sendes til navn@mail.no.",
                icon: UIImage(named: .checkCircleFilled),
                backgroundColor: .bgPrimary,
                iconTintColor: nil,
                iconBottomSpacing: .spacingL,
                titleBottomSpacing: .spacingM,
                iconHeight: 64
            )
        case .error:
            resultView.configure(
                title: "Usjda!",
                description: "Noe gikk galt.",
                actionButtonTitle: "Prøv igjen",
                icon: UIImage(named: .dissatisfiedFace),
                backgroundColor: .bgPrimary,
                iconTintColor: .textCritical,
                iconBottomSpacing: .spacingL,
                titleBottomSpacing: .spacingM,
                iconHeight: 64
            )
        }
    }
}
