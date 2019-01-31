//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public final class InfoboxView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .licorice
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = Label(style: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var primaryButton: UIButton = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var secondaryButton: UIButton = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .ice

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(primaryButton)
        addSubview(secondaryButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -.mediumLargeSpacing),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            primaryButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .mediumLargeSpacing),
            primaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: .mediumLargeSpacing),
            secondaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
