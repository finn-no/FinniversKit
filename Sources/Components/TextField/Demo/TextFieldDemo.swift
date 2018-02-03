//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class TextFieldDemo: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let emailTextField = TextField(inputType: .email)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholderText = "E-post"

        let passwordTextField = TextField(inputType: .password)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholderText = "Passord"

        addSubview(emailTextField)
        addSubview(passwordTextField)

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .mediumLargeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
