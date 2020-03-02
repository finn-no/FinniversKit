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
            emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .spacingM),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            normalTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: .spacingM),
            normalTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            normalTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            normalWithHelpTextTextField.topAnchor.constraint(equalTo: normalTextField.bottomAnchor, constant: .spacingM),
            normalWithHelpTextTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            normalWithHelpTextTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            multilineTextField.topAnchor.constraint(equalTo: normalWithHelpTextTextField.bottomAnchor, constant: .spacingM),
            multilineTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            multilineTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}
