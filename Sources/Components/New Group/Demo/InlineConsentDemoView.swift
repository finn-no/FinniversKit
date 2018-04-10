//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class InlineConsentDemoView: UIView {
    private lazy var inlineConsentView: InlineConsentView = {
        let view = InlineConsentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        inlineConsentView.descriptionText = "Vi kan bruke søkemønsteret ditt til å gi deg relevante anbefalinger fra FINN. Er det greit at vi lagrer dine søkevalg?"
        inlineConsentView.yesButtonTitle = "Ja, det er greit"
        inlineConsentView.infoButtonTitle = "Mer om samtykke"

        addSubview(inlineConsentView)

        NSLayoutConstraint.activate([
            inlineConsentView.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),
            inlineConsentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            inlineConsentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
