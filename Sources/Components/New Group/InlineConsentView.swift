//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol InlineConsentViewDelegate: NSObjectProtocol {
    func inlineConsentView(_ consentActivateDiscoverView: InlineConsentView, didSelectActivateButton button: Button)
    func inlineConsentView(_ consentActivateDiscoverView: InlineConsentView, didSelectInfoButton button: Button)
}

public class InlineConsentView: UIView {

    // MARK: - Internal properties

    private lazy var descriptionTitleLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var yesButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var infoButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - External properties / Dependency injection

    public weak var delegate: InlineConsentViewDelegate?

    public var descriptionText: String = "" {
        didSet {
            descriptionTitleLabel.text = descriptionText
        }
    }

    public var yesButtonTitle: String = "" {
        didSet {
            yesButton.setTitle(yesButtonTitle, for: .normal)
        }
    }

    public var infoButtonTitle: String = "" {
        didSet {
            infoButton.setTitle(infoButtonTitle, for: .normal)
        }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(descriptionTitleLabel)
        addSubview(yesButton)
        addSubview(infoButton)

        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            yesButton.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            yesButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            infoButton.topAnchor.constraint(equalTo: yesButton.bottomAnchor, constant: .mediumLargeSpacing),
            infoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func yesButtonTapped(_ sender: Button) {
        delegate?.inlineConsentView(self, didSelectActivateButton: sender)
    }

    @objc private func infoButtonTapped(_ sender: Button) {
        delegate?.inlineConsentView(self, didSelectInfoButton: sender)
    }

    // MARK: - Superclass overrides

    public override var intrinsicContentSize: CGSize {
        let intermediateSpacing = CGFloat.mediumLargeSpacing * 2

        guard let descriptionText = descriptionTitleLabel.text else {
            return CGSize.zero
        }
        let screenSize = UIScreen.main.bounds

        let titleHeight = descriptionText.height(withConstrainedWidth: screenSize.width - .mediumLargeSpacing * 2, font: descriptionTitleLabel.font) // .meiumLargeSpacing * 2, is margins in MarketViewController
        let activateButtonSize = CGSize(width: 130, height: 38)
        let infoButtonSize = CGSize(width: 142, height: 30)
        let widestButtonWidth = max(activateButtonSize.width, infoButtonSize.width)

        return CGSize(width: max(screenSize.width, widestButtonWidth), height: intermediateSpacing + titleHeight + activateButtonSize.height + infoButtonSize.height)
    }
}

fileprivate extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = (self as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }
}
