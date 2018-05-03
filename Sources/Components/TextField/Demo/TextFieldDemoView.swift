//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class TextFieldDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let emailTextField = TextField(inputType: .email)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholderText = "E-post"
        emailTextField.helpText = "Ikke en gyldig e-postadresse"

        let passwordTextField = TextField(inputType: .password)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholderText = "Passord"

        let normalTextField = TextField(inputType: .normal)
        normalTextField.translatesAutoresizingMaskIntoConstraints = false
        normalTextField.placeholderText = "Normal"

        let normalWithHelpTextTextField = TextField(inputType: .normal)
        normalWithHelpTextTextField.translatesAutoresizingMaskIntoConstraints = false
        normalWithHelpTextTextField.placeholderText = "Hjelpetekst"
        normalWithHelpTextTextField.helpText = "Her er en hjelpetekst"

        let multilineTextField = TextField(inputType: .multiline)
        multilineTextField.translatesAutoresizingMaskIntoConstraints = false
        multilineTextField.placeholderText = "Multiline"

        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(normalTextField)
        addSubview(multilineTextField)
        addSubview(normalWithHelpTextTextField)

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .mediumLargeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            normalTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: .mediumLargeSpacing),
            normalTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            normalTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            normalWithHelpTextTextField.topAnchor.constraint(equalTo: normalTextField.bottomAnchor, constant: .mediumLargeSpacing),
            normalWithHelpTextTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            normalWithHelpTextTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            multilineTextField.topAnchor.constraint(equalTo: normalWithHelpTextTextField.bottomAnchor, constant: .mediumLargeSpacing),
            multilineTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            multilineTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
