//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class LoginViewController: UIViewController {

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

    fileprivate lazy var infoText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = .body
        textView.textColor = .licorice
        textView.text = "Logg inn for å sende meldinger, lagre favoritter og søk. Du får også varsler når det skjer noe nytt!"
        return textView
    }()

    fileprivate lazy var forgotPasswordLabel: Label = {
        let label = Label(style: .detail(.primaryBlue))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Glemt passord"
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var loginButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(infoText)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(forgotPasswordLabel)
        view.addSubview(loginButton)

        emailTextField.presentable = TextFieldDataModel.email
        passwordTextField.presentable = TextFieldDataModel.password
        loginButton.presentable = ButtonDataModel.flat

        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            infoText.topAnchor.constraint(equalTo: view.topAnchor, constant: .largeSpacing + 64),
            infoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            infoText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            infoText.heightAnchor.constraint(equalToConstant: 85),

            emailTextField.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: .largeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .largeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            forgotPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: .mediumLargeSpacing),
            forgotPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            forgotPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            loginButton.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: .largeSpacing),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            loginButton.heightAnchor.constraint(equalToConstant: 42),
        ])
    }

    @objc func loginTapped() {
        print("Login tapped!")
    }
}
