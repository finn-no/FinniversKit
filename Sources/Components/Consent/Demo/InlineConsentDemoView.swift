//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class InlineConsentDemoView: UIView {
    private let plusScreenWidth: CGFloat = 414.0

    private lazy var inlineConsentView: InlineConsentView = {
        let margins = .mediumLargeSpacing * 2
        let consentWidth = min(frame.width, plusScreenWidth)
        let consentFrame = CGRect(x: 0, y: 0, width: (consentWidth - margins), height: frame.height)
        let view = InlineConsentView(frame: consentFrame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.descriptionText = "Vi kan vise deg relevante FINN-annonser du ikke har sett. Da trenger vi å lagre dine søkevalg."
        view.yesButtonTitle = "Ja, det er greit"
        view.infoButtonTitle = "Mer om samtykke"
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(inlineConsentView)

        NSLayoutConstraint.activate([
            inlineConsentView.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),
            inlineConsentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            inlineConsentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: .mediumLargeSpacing),
            inlineConsentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing),
            inlineConsentView.widthAnchor.constraint(equalToConstant: plusScreenWidth),
        ])
    }
}
