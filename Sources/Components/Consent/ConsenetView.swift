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

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.isAccessibilityElement = true
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [yesButton, noButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = true
        view.axis = .horizontal
        view.spacing = .mediumSpacing
        view.distribution = .fillEqually
        return view
    }()

    private lazy var descriptionTitleLabel: Label = {
        let label = Label(style: .title4(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionBodyLabel: Label = {
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
            descriptionBodyLabel.text = model.descriptionBodyText
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
        addSubview(descriptionBodyLabel)
        addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            descriptionTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            descriptionTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            descriptionBodyLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionBodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionBodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cancelButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
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
