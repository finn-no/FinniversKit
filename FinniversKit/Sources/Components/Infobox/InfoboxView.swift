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

    public private(set) var style: InfoboxView.Style

    // MARK: - Subviews

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
        if let image = style.primaryButtonIcon {
            return UIImageView(image: image, withAutoLayout: true)
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
        style = .small(backgroundColor: .bgSecondary)
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        style = .small(backgroundColor: .bgSecondary)
        super.init(coder: aDecoder)
        setup()
    }

    public init(style: InfoboxView.Style) {
        self.style = style
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 8

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(primaryButton)
        addSubview(secondaryButton)

        var constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            detailLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

            primaryButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .spacingM),
            primaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: .spacingXS),
            secondaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM)
        ]

        if let primaryButtonImageView = primaryButtonImageView {
            primaryButton.addSubview(primaryButtonImageView)
            let imageWidth: CGFloat = 18
            constraints.append(contentsOf: [
                primaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
                primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
                primaryButtonImageView.widthAnchor.constraint(equalToConstant: imageWidth),
                primaryButtonImageView.heightAnchor.constraint(equalToConstant: imageWidth),
                primaryButtonImageView.centerYAnchor.constraint(equalTo: primaryButton.centerYAnchor),
                primaryButtonImageView.trailingAnchor.constraint(equalTo: primaryButton.trailingAnchor, constant: -.spacingM),
                ])
            primaryButton.titleEdgeInsets = UIEdgeInsets(top: primaryButton.titleEdgeInsets.top, leading: primaryButton.titleEdgeInsets.leading + .spacingM + imageWidth, bottom: primaryButton.titleEdgeInsets.bottom, trailing: primaryButton.titleEdgeInsets.trailing + .spacingM + imageWidth)
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
