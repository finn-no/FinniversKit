//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - LoginViewDelegatew

public protocol RegisterViewDelegate: NSObjectProtocol {
    func registerView(_ registerView: RegisterView, didSelectLoginButton button: Button, with email: String)
    func registerView(_ registerView: RegisterView, didSelectRegisterButton button: Button, with email: String, and password: String)
    func registerView(_ registerView: RegisterView, didSelectUserTermsButton button: Button)

    func registerView(_ registerView: RegisterView, didOccurIncompleteCredentials incompleteCredentials: Bool)
}

public class RegisterView: UIView {
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

    private lazy var infoLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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

    private lazy var inputsContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private lazy var registerButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerButtonSelected), for: .touchUpInside)
        return button
    }()

    private lazy var newUserStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spidLogoImageView, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 11
        return stackView
    }()

    private lazy var spidLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: .spidLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var loginButton: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonSelected), for: .touchUpInside)
        return button
    }()

    private lazy var userTermsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userTermsIntroLabel, userTermsButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var userTermsIntroLabel: Label = {
        let label = Label(style: .detail)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var userTermsButton: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(userTermsButtonSelected), for: .touchUpInside)
        return button
    }()

    fileprivate let buttonHeight: CGFloat = 44

    private var email: String {
        guard let email = emailTextField.text else {
            return ""
        }
        return email
    }

    private var password: String {
        guard let password = passwordTextField.text else {
            return ""
        }
        return password
    }

    // MARK: - Dependency injection

    public var model: RegisterViewModel? {
        didSet {
            guard let model = model else {
                return
            }
            infoLabel.text = model.headerText
            emailTextField.placeholderText = model.emailPlaceholder
            passwordTextField.placeholderText = model.passwordPlaceholder
            loginButton.setTitle(model.loginButtonTitle, for: .normal)
            registerButton.setTitle(model.newUserButtonTitle, for: .normal)
            userTermsIntroLabel.text = model.userTermsIntroText
            userTermsButton.setTitle(model.userTermsButtonTitle, for: .normal)
        }
    }

    // MARK: - External properties

    public weak var delegate: RegisterViewDelegate?

    // MARK: - External methods

    public func update(email: String) {
        emailTextField.textField.text = email
    }

    // MARK: - Setup

    deinit {
        unRegisterKeyboardNotifications()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func didMoveToSuperview() {
        registerForKeyboardNotifications()
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func unRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func adjustKeyboard(notification: Notification) {
        guard let keyboardEndFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        if notification.name == UIResponder.keyboardWillShowNotification {
            if keyboardEndFrame.intersects(inputsContainer.frame) {
                let intersectionFrame = keyboardEndFrame.intersection(inputsContainer.frame)
                let keyboardOverlap = intersectionFrame.height
                let bottomInset = keyboardOverlap + .mediumLargeSpacing
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

                let animationDuration = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as? TimeInterval) ?? 0.25
                UIView.animate(withDuration: animationDuration) { [weak self] in
                    self?.adjustKeyboardUp(contentInset: contentInset)
                }
            }
        } else {
            let animationDuration = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as? TimeInterval) ?? 0.25
            UIView.animate(withDuration: animationDuration) { [weak self] in
                self?.adjustKeyboardDown()
            }
        }
    }

    fileprivate func adjustKeyboardUp(contentInset: UIEdgeInsets) {
        scrollView.contentInset = contentInset
        scrollView.contentOffset = CGPoint(x: 0, y: contentInset.bottom)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    fileprivate func adjustKeyboardDown() {
        scrollView.contentInset = .zero
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        registerButton.isEnabled = false

        scrollView.addSubview(contentView)
        addSubview(scrollView)
        addSubview(userTermsStackView)

        contentView.addSubview(infoLabel)
        contentView.addSubview(inputsContainer)

        inputsContainer.addSubview(emailTextField)
        inputsContainer.addSubview(passwordTextField)
        inputsContainer.addSubview(registerButton)

        contentView.addSubview(newUserStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),

            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .largeSpacing),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            inputsContainer.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: .mediumLargeSpacing),
            inputsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            inputsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            emailTextField.topAnchor.constraint(equalTo: inputsContainer.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: inputsContainer.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: inputsContainer.trailingAnchor),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .largeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: inputsContainer.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: inputsContainer.trailingAnchor),

            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: .largeSpacing),
            registerButton.leadingAnchor.constraint(equalTo: inputsContainer.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: inputsContainer.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            registerButton.bottomAnchor.constraint(equalTo: inputsContainer.bottomAnchor),

            newUserStackView.topAnchor.constraint(equalTo: inputsContainer.bottomAnchor, constant: .mediumLargeSpacing),
            newUserStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            newUserStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spidLogoImageView.heightAnchor.constraint(equalToConstant: 17),

            userTermsStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.veryLargeSpacing),
            userTermsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing)
        ])
    }

    // MARK: - Actions

    @objc func loginButtonSelected() {
        handleTap()
        delegate?.registerView(self, didSelectLoginButton: loginButton, with: email)
    }

    @objc func registerButtonSelected() {
        handleTap()
        if emailTextField.isValid && passwordTextField.isValid {
            delegate?.registerView(self, didSelectRegisterButton: registerButton, with: email, and: password)
        } else {
            delegate?.registerView(self, didOccurIncompleteCredentials: true)
        }
    }

    @objc func userTermsButtonSelected() {
        handleTap()
        delegate?.registerView(self, didSelectUserTermsButton: userTermsButton)
    }

    @objc func handleTap() {
        endEditing(true)
    }
}

// MARK: - TextFieldDelegate

extension RegisterView: TextFieldDelegate {
    public func textFieldShouldReturn(_ textField: TextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.textField.becomeFirstResponder()
        } else {
            if registerButton.isEnabled {
                registerButtonSelected()
                textField.textField.resignFirstResponder()
            } else {
                delegate?.registerView(self, didOccurIncompleteCredentials: true)
            }
        }
        return true
    }

    public func textFieldDidChange(_ textField: TextField) {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else {
            return
        }

        if emailText.isEmpty || passwordText.isEmpty {
            registerButton.isEnabled = false
        } else {
            registerButton.isEnabled = true
        }
    }
}
