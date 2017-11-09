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

        emailTextField.presentable = TextFieldDataModel.email
        passwordTextField.presentable = TextFieldDataModel.password

        view.backgroundColor = .white

        infoText.topAnchor.constraint(equalTo: view.topAnchor, constant: .largeSpacing + 64).isActive = true
        infoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing).isActive = true
        infoText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing).isActive = true
        infoText.heightAnchor.constraint(equalToConstant: 80).isActive = true

        emailTextField.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: .largeSpacing).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing).isActive = true

        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .largeSpacing).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing).isActive = true
    }
}
