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
        textView.font = .body
        textView.textColor = .licorice
        textView.text = "Logg inn for å sende meldinger, lagre favoritter og søk. Du får også varsler når det skjer noe nytt!"
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(infoText)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)

        emailTextField.model = TextFieldDataModel.email
        passwordTextField.model = TextFieldDataModel.password

        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            infoText.topAnchor.constraint(equalTo: view.topAnchor, constant: .largeSpacing + 64),
            infoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            infoText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            infoText.heightAnchor.constraint(equalToConstant: 80),

            emailTextField.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: .largeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .largeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
        ])
    }
}
