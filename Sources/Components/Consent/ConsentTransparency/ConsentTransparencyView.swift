//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ConsentTransparencyViewDelegate: AnyObject {
    func consentTransparencyView(_ consentTransparencyView: ConsentTransparencyView, didSelectMore button: Button)
    func consentTransparencyView(_ consentTransparencyView: ConsentTransparencyView, didSelectOkay button: Button)
}

public final class ConsentTransparencyView: UIView {

    // MARK: - Internal properties

    private let topImage = UIImage(named: .consentTransparencyImage)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = topImage
        return imageView
    }()

    private lazy var headerLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Din data, dine valg"
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "FINN er en del av Schibsted Norge. Når du bruker FINN er Schibsted Norge behandlingsansvarlig for påloggingsløsning og reklame, mens FINN er behandlingsansvarlig for det øvrige innholdet i tjenesten vår. Både FINN og Schibsted Norge behandler data om deg.\n\nFINN bruker dine data til å tilpasse tjenestene til deg, mens Schibsted Norge i tillegg bruker dem til å gi deg mer relevante annonser. Persondata brukes også for å sikre at tjenestene er trygge og sikre for deg."
        return label
    }()

    private lazy var moreButton: Button = {
        let button = Button(style: .flat)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        button.setTitle("Vis meg mer", for: .normal)
        return button
    }()

    private lazy var okayButton: Button = {
        let button = Button(style: .callToAction)
        button.addTarget(self, action: #selector(okayButtonTapped), for: .touchUpInside)
        button.setTitle("Jeg forstår", for: .normal)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [moreButton, okayButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = .mediumLargeSpacing
        view.distribution = .fillEqually
        return view
    }()

    // MARK: - External properties / Dependency injection

    weak var delegate: ConsentTransparencyViewDelegate?

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

// MARK: - Private

private extension ConsentTransparencyView {
    func setup() {
        addSubview(imageView)
        addSubview(headerLabel)
        addSubview(detailLabel)
        addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: .mediumLargeSpacing),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            headerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumLargeSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            detailLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .mediumSpacing),
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            buttonStackView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .largeSpacing),
            buttonStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: .mediumLargeSpacing),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    @objc func moreButtonTapped(_ sender: Button) {
        delegate?.consentTransparencyView(self, didSelectMore: sender)
    }

    @objc func okayButtonTapped(_ sender: Button) {
        delegate?.consentTransparencyView(self, didSelectOkay: sender)
    }
}
