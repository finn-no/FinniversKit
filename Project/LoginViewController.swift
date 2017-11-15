//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class LoginViewController: UIViewController {

    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate lazy var emailTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    fileprivate lazy var passwordTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    fileprivate lazy var infoText: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Logg inn for å sende meldinger, lagre favoritter og søk. Du får også varsler når det skjer noe nytt!"
        return label
    }()

    fileprivate lazy var loginButton: Button = {
        let button = Button(style: .flat)
        button.setTitle("Logg inn", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var forgotPasswordButton: Button = {
        let button = Button(style: .link)
        button.setTitle("Glemt passord", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var newUserButton: Button = {
        let button = Button(style: .default)
        button.setTitle("Ny bruker", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(newUserTapped), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var userTermsButton: Button = {
        let button = Button(style: .link)
        button.setTitle("Brukervilkår", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(userTermsTapped), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var userTermsIntro: Label = {
        let label = Label(style: .detail(.licorice))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ved å logge inn aksepterer du burkervilkårene våres"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    fileprivate let buttonHeight: CGFloat = 44

    private func setupView() {
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        contentView.addSubview(infoText)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(newUserButton)
        contentView.addSubview(userTermsIntro)
        contentView.addSubview(userTermsButton)

        emailTextField.presentable = TextFieldDataModel.email
        passwordTextField.presentable = TextFieldDataModel.password

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)

        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            infoText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .largeSpacing),
            infoText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            infoText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            emailTextField.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: .mediumLargeSpacing),
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

            userTermsIntro.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: .largeSpacing),
            userTermsIntro.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            userTermsIntro.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            userTermsButton.topAnchor.constraint(equalTo: userTermsIntro.bottomAnchor, constant: .mediumLargeSpacing),
            userTermsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            userTermsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),
            userTermsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.largeSpacing),
        ])
    }

    @objc func loginTapped() {
        print("Login tapped!")
    }

    @objc func forgotPasswordTapped() {
        print("Forgott password button tapped!")
    }

    @objc func newUserTapped() {
        print("New user tapped")
    }

    @objc func userTermsTapped() {
        print("User terms tapped")
    }

    @objc func handleTap() {
        view.endEditing(true)
    }
}
