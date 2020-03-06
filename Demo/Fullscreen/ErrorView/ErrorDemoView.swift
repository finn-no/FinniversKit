//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class ErrorDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "All elements", description: "", action: {
            self.errorView.configure(
                title: "Klarte ikke å finne annonsen",
                description: "Det kan se ut som at annonsen du\nkikker etter er blitt slettet.",
                icon: UIImage(named: .magnifyingGlass).withRenderingMode(.alwaysTemplate)
            )
        }),
        TweakingOption(title: "Colored title", description: "", action: {
            self.errorView.configure(title: "Prøv igjen", titleColor: .textAction)
        }),
        TweakingOption(title: "Colored title multiple lines", description: "", action: {
            self.errorView.configure(
                title: "Denne annonsetypen støttesikke i appen, trykk for å åpne i Safari",
                titleColor: .textAction
            )
        }),
        TweakingOption(title: "Just title", description: "", action: {
            self.errorView.configure(
                title: "Du mangler nettforbindelse"
            )
        }),
    ]

    private lazy var errorView = ErrorView(withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        tweakingOptions.first?.action?()
        addSubview(errorView)
        errorView.fillInSuperview()
    }
}
