//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - LoginViewDelegatew

public protocol ConsentViewDelegate: NSObjectProtocol {
    func consentView(_ consentView: ConsentView, didSelectYesButton button: Button)
    func consentView(_ consentView: ConsentView, didSelectNoButton button: Button)
    func consentView(_ consentView: ConsentView, didSelectCancelButton button: UIButton)
}

public class ConsentView: UIView {

    // MARK: - Internal properties

    private let noImage: UIImage = UIImage(frameworkImageNamed: "NoImage")!

    private lazy var yesButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var noButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [yesButton, noButton])
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
        return imageView
    }()

    private lazy var descriptionTitleLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isAccessibilityElement = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.contentMode = .topLeft
        textView.font = .body
        textView.textColor = .licorice
        return textView
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
            descriptionTextView.text = model.descriptionBodyText
            descriptionTextView.accessibilityLabel = model.descriptionBodyText

            if let image = model.image { // TODO: (UUS): Async loading og image
                imageView.image = image
            } else {
                imageView.image = noImage
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
        addSubview(cancelButton)
        addSubview(descriptionTitleLabel)
        addSubview(descriptionTextView)
        addSubview(buttonStackView)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            cancelButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing),

            descriptionTitleLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: .largeSpacing),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            descriptionTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing),

            imageView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumSpacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
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

    @objc private func cancelButtonTapped(button: UIButton) {
        delegate?.consentView(self, didSelectCancelButton: button)
    }
}
