//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol InfoboxViewDelegate: AnyObject {
    func infoboxViewDidSelectPrimaryButton(_ view: InfoboxView)
    func infoboxViewDidSelectSecondaryButton(_ view: InfoboxView)
}

public final class InfoboxView: UIView {
    public weak var delegate: InfoboxViewDelegate?

    public var model: InfoboxViewModel? {
        didSet {
            titleLabel.text = model?.title
            detailLabel.text = model?.detail
            primaryButton.setTitle(model?.primaryButtonTitle, for: .normal)
            secondaryButton.setTitle(model?.secondaryButtonTitle, for: .normal)
        }
    }

    // MARK: - Subviews

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
        let button = Button(style: .default, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var secondaryButton: UIButton = {
        let button = Button(style: .flat, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSecondaryButtonTap), for: .touchUpInside)
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
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            detailLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

            primaryButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .mediumLargeSpacing),
            primaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: .smallSpacing),
            secondaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
        ])
    }

    // MARK: - Actions

    @objc private func handlePrimaryButtonTap() {
        delegate?.infoboxViewDidSelectPrimaryButton(self)
    }

    @objc private func handleSecondaryButtonTap() {
        delegate?.infoboxViewDidSelectSecondaryButton(self)
    }
}
