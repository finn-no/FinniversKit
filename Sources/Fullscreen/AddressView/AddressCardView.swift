//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

class AddressCardView: UIView {
    lazy var addressLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vadmyrveien 18"
        return label
    }()

    lazy var postalCodeLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5172 Loddefjord"
        return label
    }()

    lazy var copyAddressButton: Button = {
        let button = Button(style: .default, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Kopier adresse", for: .normal)
        return button
    }()

    lazy var getDirectionsButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Åpne veibeskrivelse", for: .normal)
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension AddressCardView {
    func setup() {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = 10
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }

        backgroundColor = .white

        let columnStackView = UIStackView(arrangedSubviews: [addressLabel, postalCodeLabel])
        columnStackView.translatesAutoresizingMaskIntoConstraints = false
        columnStackView.axis = .vertical
        columnStackView.distribution = .equalCentering
        columnStackView.spacing = .mediumLargeSpacing

        addSubview(columnStackView)
        addSubview(copyAddressButton)
        addSubview(getDirectionsButton)

        NSLayoutConstraint.activate([
            columnStackView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            columnStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),

            copyAddressButton.bottomAnchor.constraint(equalTo: getDirectionsButton.topAnchor, constant: -.mediumLargeSpacing),
            copyAddressButton.leadingAnchor.constraint(equalTo: columnStackView.trailingAnchor, constant: .mediumLargeSpacing),
            copyAddressButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            getDirectionsButton.topAnchor.constraint(equalTo: columnStackView.bottomAnchor, constant: .mediumLargeSpacing),
            getDirectionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            getDirectionsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            getDirectionsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
            ])
    }
}
