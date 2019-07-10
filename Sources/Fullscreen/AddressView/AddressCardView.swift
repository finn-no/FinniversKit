//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

protocol AddressCardViewDelegate: class {
    func addressCardViewDidSelectCopyButton(_ addressCardView: AddressCardView)
    func addressCardViewDidSelectGetDirectionsButton(_ addressCardView: AddressCardView)
}

class AddressCardView: UIView {
    weak var delegate: AddressCardViewDelegate?

    lazy var titleLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subtitleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var copyButton: Button = {
        let button = Button(style: .default, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        return button
    }()

    lazy var getDirectionsButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(getDirectionsAction), for: .touchUpInside)
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
    private func setup() {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor

        backgroundColor = .white

        let columnStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        columnStackView.translatesAutoresizingMaskIntoConstraints = false
        columnStackView.axis = .vertical
        columnStackView.distribution = .equalCentering
        columnStackView.spacing = .mediumSpacing

        addSubview(columnStackView)
        addSubview(copyButton)
        addSubview(getDirectionsButton)

        NSLayoutConstraint.activate([
            columnStackView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            columnStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            columnStackView.trailingAnchor.constraint(lessThanOrEqualTo: copyButton.leadingAnchor, constant: .mediumLargeSpacing),

            copyButton.centerYAnchor.constraint(equalTo: columnStackView.centerYAnchor),
            copyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            getDirectionsButton.topAnchor.constraint(equalTo: columnStackView.bottomAnchor, constant: .mediumLargeSpacing),
            getDirectionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            getDirectionsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            getDirectionsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
            ])
    }

    @objc func getDirectionsAction() {
        delegate?.addressCardViewDidSelectGetDirectionsButton(self)
    }

    @objc func copyAction() {
        delegate?.addressCardViewDidSelectCopyButton(self)
    }
}
