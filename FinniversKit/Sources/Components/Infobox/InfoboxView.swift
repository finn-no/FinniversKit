//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public protocol InfoboxViewDelegate: AnyObject {
    func infoboxViewDidSelectPrimaryButton(_ view: InfoboxView)
    func infoboxViewDidSelectSecondaryButton(_ view: InfoboxView)
}

public final class InfoboxView: UIView {
    public weak var delegate: InfoboxViewDelegate?
    public private(set) var style: InfoboxView.Style

    public var model: InfoboxViewModel? {
        didSet {
            titleLabel.text = model?.title
            detailLabel.text = model?.detail

            if let primaryButtonTitle = model?.primaryButtonTitle,
               !primaryButtonTitle.isEmpty {
                primaryButton.setTitle(primaryButtonTitle, for: .normal)
            } else {
                primaryButton.isHidden = true
            }

            if let secondaryButtonTitle = model?.secondaryButtonTitle,
               !secondaryButtonTitle.isEmpty {
                secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
            } else {
                secondaryButton.isHidden = true
            }
        }
    }

    // MARK: - Subviews

    private lazy var stackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing100, alignment: .center, distribution: .fill, withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let label = Label(style: style.titleStyle, textColor: style.textColor, withAutoLayout: true)
        label.textAlignment = .center
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = Label(style: style.detailStyle, numberOfLines: 0, textColor: style.textColor, withAutoLayout: true)
        label.textAlignment = .center
        return label
    }()

    private lazy var primaryButton: UIButton = {
        let button = Button(style: style.primaryButtonStyle, size: style.primaryButtonSize, withAutoLayout: true)
        button.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var primaryButtonImageView: UIImageView? = {
        if let image = style.primaryButtonIcon?.withRenderingMode(.alwaysTemplate) {
            let imageView = UIImageView(image: image, withAutoLayout: true)
            imageView.tintColor = Warp.UIToken.iconInverted
            return imageView
        }
        return nil
    }()

    private lazy var secondaryButton: UIButton = {
        let button = Button(style: style.secondaryButtonStyle, size: style.secondaryButtonSize, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleSecondaryButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        style = .small(backgroundColor: .backgroundInfoSubtle)
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        style = .small(backgroundColor: .backgroundInfoSubtle)
        super.init(coder: aDecoder)
        setup()
    }

    public init(style: InfoboxView.Style, withAutoLayout: Bool = false) {
        self.style = style
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 8

        stackView.addArrangedSubviews([titleLabel, detailLabel, primaryButton, secondaryButton])
        stackView.setCustomSpacing(Warp.Spacing.spacing200, after: detailLabel)
        stackView.setCustomSpacing(Warp.Spacing.spacing50, after: primaryButton)

        addSubview(stackView)
        stackView.fillInSuperview(margin: Warp.Spacing.spacing200)

        var constraints: [NSLayoutConstraint] = [
            detailLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
        ]

        if let primaryButtonImageView = primaryButtonImageView {
            primaryButton.addSubview(primaryButtonImageView)

            let imageWidth: CGFloat = 18
            constraints.append(contentsOf: [
                primaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
                primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
                primaryButtonImageView.widthAnchor.constraint(equalToConstant: imageWidth),
                primaryButtonImageView.heightAnchor.constraint(equalToConstant: imageWidth),
                primaryButtonImageView.centerYAnchor.constraint(equalTo: primaryButton.centerYAnchor),
                primaryButtonImageView.trailingAnchor.constraint(equalTo: primaryButton.trailingAnchor, constant: -Warp.Spacing.spacing200),
            ])

            primaryButton.titleEdgeInsets = UIEdgeInsets(
                top: primaryButton.titleEdgeInsets.top,
                leading: primaryButton.titleEdgeInsets.leading + Warp.Spacing.spacing200 + imageWidth,
                bottom: primaryButton.titleEdgeInsets.bottom,
                trailing: primaryButton.titleEdgeInsets.trailing + Warp.Spacing.spacing200 + imageWidth
            )
        }

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Actions

    @objc private func handlePrimaryButtonTap() {
        delegate?.infoboxViewDidSelectPrimaryButton(self)
    }

    @objc private func handleSecondaryButtonTap() {
        delegate?.infoboxViewDidSelectSecondaryButton(self)
    }
}
