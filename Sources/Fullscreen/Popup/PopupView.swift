//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - PopupViewDelegate

public protocol PopupViewDelegate: NSObjectProtocol {
    func popupView(_ popupView: PopupView, didSelectCallToActionButton button: Button)
    func popupView(_ popupView: PopupView, didSelectAlternativeActionButton button: Button)
    func popupView(_ popupView: PopupView, didSelectDismissButton button: Button)
    func popupView(_ popupView: PopupView, didSelectLinkButton button: Button)
}

public extension PopupViewDelegate {
    func popupView(_ popupView: PopupView, didSelectDismissButton button: Button) {
        // Doesn't need to be implemented
    }

    func popupView(_ popupView: PopupView, didSelectLinkButton button: Button) {
        // Doesn't need to be implemented
    }
}

public class PopupView: UIView {

    // MARK: - Internal properties

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var dismissButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionTitleLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var alternativeActionButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(alternativeActionButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var callToActionButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(callToActionButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [alternativeActionButton, callToActionButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = .mediumLargeSpacing
        view.distribution = .fillEqually
        return view
    }()

    // MARK: - External properties / Dependency injection

    public weak var delegate: PopupViewDelegate?

    public var model: PopupViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            callToActionButton.setTitle(model.callToActionButtonTitle, for: .normal)
            alternativeActionButton.setTitle(model.alternativeActionButtonTitle, for: .normal)

            if let topRightButtonTitle = model.dismissButtonTitle, topRightButtonTitle != "" {
                dismissButton.isHidden = false
                dismissButton.setTitle(topRightButtonTitle, for: .normal)
            } else {
                dismissButton.isHidden = true
            }

            if let linkButtonTitle = model.linkButtonTitle, linkButtonTitle != "" {
                linkButton.isHidden = false
                linkButton.setTitle(linkButtonTitle, for: .normal)
            } else {
                linkButton.isHidden = true
            }
            descriptionTitleLabel.text = model.descriptionTitle
            if let attributedString = model.attributedDescriptionText {
                descriptionLabel.attributedText = attributedString
            } else {
                descriptionLabel.text = model.descriptionText
            }

            imageView.image = model.image
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(dismissButton)
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(linkButton)
        addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -.mediumSpacing),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            dismissButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            dismissButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            dismissButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            imageView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: .mediumLargeSpacing),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            descriptionTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumLargeSpacing),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            descriptionTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            linkButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .mediumLargeSpacing),
            linkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            linkButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            linkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    // MARK: - Private actions

    @objc private func callToActionButtonTapped(button: Button) {
        delegate?.popupView(self, didSelectCallToActionButton: button)
    }

    @objc private func alternativeActionButtonTapped(button: Button) {
        delegate?.popupView(self, didSelectAlternativeActionButton: button)
    }

    @objc private func dismissButtonTapped(button: Button) {
        delegate?.popupView(self, didSelectDismissButton: button)
    }

    @objc private func linkButtonTapped(button: Button) {
        delegate?.popupView(self, didSelectLinkButton: button)
    }
}
