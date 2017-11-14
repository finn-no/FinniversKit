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
        let button = Button(style: .normal)
        button.setTitle("Glemt passord", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var newUserButton: Button = {
        let button = Button(style: .normal)
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

    private func setupView() {
        view.addSubview(infoText)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(newUserButton)
        view.addSubview(userTermsIntro)
        view.addSubview(userTermsButton)

        emailTextField.presentable = TextFieldDataModel.email
        passwordTextField.presentable = TextFieldDataModel.password

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)

        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            infoText.topAnchor.constraint(equalTo: view.topAnchor, constant: .largeSpacing + navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height),
            infoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            infoText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            emailTextField.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: .largeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .largeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: .largeSpacing),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: .mediumSpacing),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2 - .largeSpacing - .smallSpacing),

            newUserButton.topAnchor.constraint(equalTo: forgotPasswordButton.topAnchor),
            newUserButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            newUserButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2 - .largeSpacing - .smallSpacing),

            userTermsIntro.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: .mediumLargeSpacing),
            userTermsIntro.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            userTermsIntro.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            userTermsButton.topAnchor.constraint(equalTo: userTermsIntro.bottomAnchor, constant: .mediumSpacing),
            userTermsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            userTermsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
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
