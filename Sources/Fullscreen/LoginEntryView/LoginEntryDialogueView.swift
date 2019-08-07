//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class LoginEntryDialogueView: UIView {
    // MARK: - Internal properties

    weak var delegate: LoginEntryViewDelegate?

    // MARK: - Private properties

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .finnLogo)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        // overriding the font to get the title2 strong without affecting
        // the design system itself for now
        let title2StrongFont = UIFont(name: FontType.medium.rawValue, size: 28.0)!
            .scaledFont(forTextStyle: .title2)

        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = title2StrongFont
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginButtonTap), for: .touchUpInside)

        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegisterButtonTap), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0

        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Internal methods

    func configure(with model: LoginEntryViewModel) {
        titleLabel.text = model.title
        detailLabel.text = model.detail
        loginButton.setTitle(model.loginButtonTitle, for: .normal)
        registerButton.setTitle(model.registerButtonTitle, for: .normal)
    }

    // MARK: - Private methods

    private func setup() {
        layer.cornerRadius = 33

        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(loginButton)
        addSubview(registerButton)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: .veryLargeSpacing),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
            logoImageView.heightAnchor.constraint(equalToConstant: 56),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: .largeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing + .largeSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing - .largeSpacing),

            loginButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .largeSpacing),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: .mediumLargeSpacing),
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
            registerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.largeSpacing),
        ])
    }

    @objc private func handleLoginButtonTap() {
        delegate?.loginEntryViewDidSelectLoginButton()
    }

    @objc private func handleRegisterButtonTap() {
        delegate?.loginEntryViewDidSelectRegisterButton()
    }
}
