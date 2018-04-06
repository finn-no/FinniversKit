//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - ConsentViewDelegate

public protocol ConsentViewDelegate: NSObjectProtocol {
    func consentView(_ consentView: ConsentView, didSelectYesButton button: Button)
    func consentView(_ consentView: ConsentView, didSelectNoButton button: Button)
    func consentView(_ consentView: ConsentView, didSelectCancelButton button: Button)
}

public class ConsentView: UIView {

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

    private let noImage: UIImage = UIImage(frameworkImageNamed: "NoImage")!

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

    private lazy var cancelButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(frameworkImageNamed: "consentViewImage1")
        return imageView
    }()

    private lazy var descriptionTitleLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var introDescriptionLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionBulletPointsLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    // MARK: - External properties / Dependency injection

    public weak var delegate: ConsentViewDelegate?

    public var model: ConsentViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            yesButton.setTitle(model.yesButtonTitle, for: .normal)
            noButton.setTitle(model.noButtonTitle, for: .normal)
            cancelButton.setTitle(model.cancelButtonTitle, for: .normal)
            descriptionTitleLabel.text = model.descriptionTitle
            introDescriptionLabel.text = model.descriptionIntroText
            descriptionBulletPointsLabel.attributedText = model.formatedBulletPoints(with: .body)
            descriptionLabel.text = model.descriptionText
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
        contentView.addSubview(introDescriptionLabel)
        contentView.addSubview(descriptionBulletPointsLabel)
        contentView.addSubview(descriptionLabel)
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

            imageView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: .mediumLargeSpacing),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            descriptionTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .largeSpacing),
            descriptionTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            descriptionTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            descriptionTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            introDescriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            introDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            introDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            descriptionBulletPointsLabel.topAnchor.constraint(equalTo: introDescriptionLabel.bottomAnchor, constant: .mediumSpacing),
            descriptionBulletPointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            descriptionBulletPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionBulletPointsLabel.bottomAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    // MARK: - Private actions

    @objc private func yesButtonTapped(button: Button) {
        delegate?.consentView(self, didSelectYesButton: button)
    }

    @objc private func noButtonTapped(button: Button) {
        delegate?.consentView(self, didSelectNoButton: button)
    }

    @objc private func cancelButtonTapped(button: Button) {
        delegate?.consentView(self, didSelectCancelButton: button)
    }
}
