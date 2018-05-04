//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - ConsentViewDelegate

public protocol PopupConsentViewDelegate: NSObjectProtocol {
    func popupConsentView(_ popupConsentView: PopupConsentView, didSelectYesButton button: Button)
    func popupConsentView(_ popupConsentView: PopupConsentView, didSelectNoButton button: Button)
    func popupConsentView(_ popupConsentView: PopupConsentView, didSelectCancelButton button: Button)
    func popupConsentView(_ popupConsentView: PopupConsentView, didSelectInfoButton button: Button)
}

public class PopupConsentView: UIView {

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

    private lazy var cancelButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionTitleLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var infoButton: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var noButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var yesButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [noButton, yesButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = .mediumLargeSpacing
        view.distribution = .fillEqually
        return view
    }()

    // MARK: - External properties / Dependency injection

    public weak var delegate: PopupConsentViewDelegate?

    public var model: PopupConsentViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            yesButton.setTitle(model.yesButtonTitle, for: .normal)
            noButton.setTitle(model.noButtonTitle, for: .normal)

            if let cancelButtonTitle = model.cancelButtonTitle, cancelButtonTitle != "" {
                cancelButton.isHidden = false
                cancelButton.setTitle(cancelButtonTitle, for: .normal)
            } else {
                cancelButton.isHidden = true
            }

            if let infoButtonTitle = model.infoButtonTitle, infoButtonTitle != "" {
                infoButton.isHidden = false
                infoButton.setTitle(infoButtonTitle, for: .normal)
            } else {
                infoButton.isHidden = true
            }
            descriptionTitleLabel.text = model.descriptionTitle
            descriptionLabel.text = model.descriptionText

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

        contentView.addSubview(cancelButton)
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(infoButton)
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

            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            cancelButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            imageView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: .veryLargeSpacing),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            descriptionTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumLargeSpacing),
            descriptionTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            descriptionTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            descriptionTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            infoButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .mediumLargeSpacing),
            infoButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            infoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    // MARK: - Private actions

    @objc private func yesButtonTapped(button: Button) {
        delegate?.popupConsentView(self, didSelectYesButton: button)
    }

    @objc private func noButtonTapped(button: Button) {
        delegate?.popupConsentView(self, didSelectNoButton: button)
    }

    @objc private func cancelButtonTapped(button: Button) {
        delegate?.popupConsentView(self, didSelectCancelButton: button)
    }

    @objc private func infoButtonTapped(button: Button) {
        delegate?.popupConsentView(self, didSelectInfoButton: button)
    }
}
