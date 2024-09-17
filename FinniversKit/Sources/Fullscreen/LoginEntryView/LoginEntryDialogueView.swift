//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

class LoginEntryDialogueView: UIView {
    // MARK: - Internal properties

    weak var delegate: LoginEntryViewDelegate?

    // MARK: - Private properties

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        // overriding the font to get the title2 strong without affecting
        // the design system itself for now
        let title2StrongFont = UIFont.title2
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
        logoImageView.image = model.icon
    }

    // MARK: - Private methods

    private func setup() {
        layer.cornerRadius = 33
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Warp.Spacing.spacing800, leading: Warp.Spacing.spacing400, bottom: Warp.Spacing.spacing400, trailing: Warp.Spacing.spacing400
        )

        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(loginButton)
        addSubview(registerButton)

        let margins = layoutMarginsGuide
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: margins.topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 56),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Warp.Spacing.spacing400),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Warp.Spacing.spacing100),
            detailLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: Warp.Spacing.spacing100),
            detailLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -Warp.Spacing.spacing100),

            loginButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: Warp.Spacing.spacing400),
            loginButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Warp.Spacing.spacing200),
            registerButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            registerButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }

    @objc private func handleLoginButtonTap() {
        delegate?.loginEntryViewDidSelectLoginButton()
    }

    @objc private func handleRegisterButtonTap() {
        delegate?.loginEntryViewDidSelectRegisterButton()
    }
}
