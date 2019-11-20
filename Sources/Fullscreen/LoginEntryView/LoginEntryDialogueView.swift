//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Bootstrap

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
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title2Strong
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
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: .veryLargeSpacing, leading: .largeSpacing, bottom: .largeSpacing, trailing: .largeSpacing
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

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: .largeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            detailLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: .mediumSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -.mediumSpacing),

            loginButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .largeSpacing),
            loginButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: .mediumLargeSpacing),
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
