//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

class AddressCardView: UIView {
    lazy var addressLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var postalCodeLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var secondaryButton: Button = {
        let button = Button(style: .default, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var primaryButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
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
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }

        backgroundColor = .white

        let columnStackView = UIStackView(arrangedSubviews: [addressLabel, postalCodeLabel])
        columnStackView.translatesAutoresizingMaskIntoConstraints = false
        columnStackView.axis = .vertical
        columnStackView.distribution = .equalCentering
        columnStackView.spacing = .mediumSpacing

        addSubview(columnStackView)
        addSubview(secondaryButton)
        addSubview(primaryButton)

        NSLayoutConstraint.activate([
            columnStackView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            columnStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),

            secondaryButton.centerYAnchor.constraint(equalTo: columnStackView.centerYAnchor),
            secondaryButton.leadingAnchor.constraint(equalTo: columnStackView.trailingAnchor, constant: .mediumLargeSpacing),
            secondaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            primaryButton.topAnchor.constraint(equalTo: columnStackView.bottomAnchor, constant: .mediumLargeSpacing),
            primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            primaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
            ])
    }
}
