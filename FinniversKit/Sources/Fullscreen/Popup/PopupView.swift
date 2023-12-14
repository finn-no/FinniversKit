//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - PopupViewDelegate

public protocol PopupViewDelegate: AnyObject {
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
        let button = Button(style: .flat, withAutoLayout: true)
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
        let label = Label(style: .title3, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: .link, withAutoLayout: true)
        button.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var alternativeActionButton: Button = {
        let button = Button(style: .flat, withAutoLayout: true)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.addTarget(self, action: #selector(alternativeActionButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var callToActionButton: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.addTarget(self, action: #selector(callToActionButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [alternativeActionButton, callToActionButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = .spacingM
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
            descriptionTitleLabel.text = model.descriptionTitle
            imageView.image = model.image

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

            if let attributedString = model.attributedDescriptionText {
                descriptionLabel.attributedText = attributedString
            } else {
                descriptionLabel.text = model.descriptionText
            }
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
            scrollView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -.spacingS),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            dismissButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            dismissButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            dismissButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.spacingM),

            imageView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: .spacingM),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            descriptionTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .spacingS),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            descriptionTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.spacingM),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: .spacingS),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            linkButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .spacingM),
            linkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            linkButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.spacingM),
            linkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
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
