//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol LoginScreenDelegate: NSObjectProtocol {
    func forgotPasswordButtonPressed(in: LoginScreen)
    func loginButtonPressed(in: LoginScreen)
    func newUserButtonPressed(in: LoginScreen)
    func userTermsButtonPressed(in: LoginScreen)
}

public class LoginScreen: UIView {

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

    fileprivate lazy var emailTextField: TextField = {
        let textField = TextField(inputType: .email)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    fileprivate lazy var passwordTextField: TextField = {
        let textField = TextField(inputType: .password)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var infoLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var loginButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()

    private lazy var forgotPasswordButton: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()

    private lazy var newUserButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(newUserTapped), for: .touchUpInside)
        return button
    }()

    private lazy var userTermsButton: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(userTermsTapped), for: .touchUpInside)
        return button
    }()

    private lazy var userTermsIntroLabel: Label = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    fileprivate let buttonHeight: CGFloat = 44

    // MARK: - External properties / Dependency injection

    public var model: LoginScreenModel? {
        didSet {
            guard let model = model else {
                return
            }
            infoLabel.text = model.headerText
            emailTextField.placeholderText = model.emailPlaceholder
            passwordTextField.placeholderText = model.passwordPlaceholder
            forgotPasswordButton.setTitle(model.forgotPasswordButtonTitle, for: .normal)
            loginButton.setTitle(model.loginButtonTitle, for: .normal)
            newUserButton.setTitle(model.newUserButtonTitle, for: .normal)
            userTermsIntroLabel.text = model.userTermsIntroText
            userTermsButton.setTitle(model.userTermsButtonTitle, for: .normal)
        }
    }

    public weak var delegate: LoginScreenDelegate?

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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        loginButton.isEnabled = false

        scrollView.addSubview(contentView)
        addSubview(scrollView)

        contentView.addSubview(infoLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(newUserButton)
        contentView.addSubview(userTermsIntroLabel)
        contentView.addSubview(userTermsButton)
    }

    // MARK: - Superclass Overrides

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .largeSpacing),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            emailTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: .mediumLargeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .largeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: .mediumSpacing),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: .largeSpacing),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),
            loginButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            newUserButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: .mediumSpacing),
            newUserButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            newUserButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),
            newUserButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            userTermsIntroLabel.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: .largeSpacing),
            userTermsIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            userTermsIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            userTermsButton.topAnchor.constraint(equalTo: userTermsIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
            userTermsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            userTermsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),
            userTermsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.largeSpacing),
        ])
    }

    // MARK: - Private

    // MARK: - Actions

    @objc func loginTapped() {
        delegate?.loginButtonPressed(in: self)
    }

    @objc func forgotPasswordTapped() {
        delegate?.forgotPasswordButtonPressed(in: self)
    }

    @objc func newUserTapped() {
        delegate?.newUserButtonPressed(in: self)
    }

    @objc func userTermsTapped() {
        delegate?.userTermsButtonPressed(in: self)
    }

    @objc func handleTap() {
        endEditing(true)
    }
}

extension LoginScreen: TextFieldDelegate {
    public func textFieldShouldReturn(_ textField: TextField) -> Bool {
        if textField == passwordTextField {
            if loginButton.isEnabled {
                textField.endEditing(true)
                loginTapped()
            } else {
                delegate?.incompleteCredentials(in: self)
            }
        }
        return true
    }

    public func textFieldDidChange(_ textField: TextField) {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else {
            return
        }

        if emailText.isEmpty || passwordText.isEmpty {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
}
