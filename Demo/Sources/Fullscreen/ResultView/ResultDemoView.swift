//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class ResultDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "All elements", description: "", action: {
            self.resultView.configure(
                title: "Klarte ikke å finne annonsen",
                description: "Det kan se ut som at annonsen du\nkikker etter er blitt slettet.",
                icon: UIImage(named: .magnifyingGlass).withRenderingMode(.alwaysTemplate)
            )
        }),
        TweakingOption(title: "Colored title", description: "", action: {
            self.resultView.configure(title: "Prøv igjen", titleColor: .textAction)
        }),
        TweakingOption(title: "Colored title multiple lines", description: "", action: {
            self.resultView.configure(
                title: "Denne annonsetypen støttesikke i appen, trykk for å åpne i Safari",
                titleColor: .textAction
            )
        }),
        TweakingOption(title: "Just title", description: "", action: {
            self.resultView.configure(
                title: "Du mangler nettforbindelse"
            )
        }),
        TweakingOption(title: "Success", description: "", action: {
            self.resultView.configure(
                title: "Hurra!",
                description: "En bekreftelse sendes til navn@mail.no.",
                icon: UIImage(named: .checkCircleFilled),
                backgroundColor: .bgPrimary,
                iconTintColor: nil,
                iconBottomSpacing: .spacingL,
                titleBottomSpacing: .spacingM,
                iconHeight: 64
            )
        }),
        TweakingOption(title: "Error", description: "", action: {
            self.resultView.configure(
                title: "Usjda!",
                description: "Noe gikk galt.",
                icon: UIImage(named: .dissatisfiedFace),
                backgroundColor: .bgPrimary,
                iconTintColor: .textCritical,
                iconBottomSpacing: .spacingL,
                titleBottomSpacing: .spacingM,
                iconHeight: 64
            )
        }),
    ]

    private lazy var resultView = ResultView(withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        tweakingOptions.first?.action?()
        addSubview(resultView)
        resultView.fillInSuperview()
    }
}
