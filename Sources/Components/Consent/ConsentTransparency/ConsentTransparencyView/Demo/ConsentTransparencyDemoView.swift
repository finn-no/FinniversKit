//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ConsentTransparencyDemoView: UIView {
    private let maxScreenSize = CGSize(width: 414, height: 736)

    private lazy var shadedBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()

    private lazy var consentTransparencyView: ConsentTransparencyView = {
        let view = ConsentTransparencyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .milk
        view.headerText = "Din data, dine valg"
        view.detailText = "FINN er en del av Schibsted Norge. Når du bruker FINN er Schibsted Norge behandlingsansvarlig for påloggingsløsning og reklame, mens FINN er behandlingsansvarlig for det øvrige innholdet i tjenesten vår. Både FINN og Schibsted Norge behandler data om deg.\n\nFINN bruker dine data til å tilpasse tjenestene til deg, mens Schibsted Norge i tillegg bruker dem til å gi deg mer relevante annonser. Persondata brukes også for å sikre at tjenestene er trygge og sikre for deg."
        view.moreButtonTitle = "Vis meg mer"
        view.okayButtonTitle = "Jeg forstår"
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(shadedBackgroundView)
        shadedBackgroundView.addSubview(consentTransparencyView)

        shadedBackgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            consentTransparencyView.topAnchor.constraint(greaterThanOrEqualTo: shadedBackgroundView.topAnchor, constant: .largeSpacing),
            consentTransparencyView.bottomAnchor.constraint(lessThanOrEqualTo: shadedBackgroundView.bottomAnchor, constant: -.largeSpacing),
            consentTransparencyView.leadingAnchor.constraint(greaterThanOrEqualTo: shadedBackgroundView.leadingAnchor, constant: .largeSpacing),
            consentTransparencyView.trailingAnchor.constraint(lessThanOrEqualTo: shadedBackgroundView.trailingAnchor, constant: -.largeSpacing),
            consentTransparencyView.centerXAnchor.constraint(equalTo: shadedBackgroundView.centerXAnchor),
            consentTransparencyView.centerYAnchor.constraint(equalTo: shadedBackgroundView.centerYAnchor),
            consentTransparencyView.widthAnchor.constraint(equalToConstant: maxScreenSize.width),
            consentTransparencyView.heightAnchor.constraint(equalToConstant: maxScreenSize.height),
        ])
    }
}
