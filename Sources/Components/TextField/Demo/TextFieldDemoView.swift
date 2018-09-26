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
        let normalTextField = TextField(inputType: .normal)
        normalTextField.translatesAutoresizingMaskIntoConstraints = false
        normalTextField.placeholderText = "Normal"

        let emailTextField = TextField(inputType: .email)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholderText = "E-post"
        emailTextField.helpText = "Ikke en gyldig e-postadresse"

        let passwordTextField = TextField(inputType: .password)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholderText = "Passord"

        let normalWithHelpTextTextField = TextField(inputType: .normal)
        normalWithHelpTextTextField.translatesAutoresizingMaskIntoConstraints = false
        normalWithHelpTextTextField.placeholderText = "Hjelpetekst"
        normalWithHelpTextTextField.helpText = "Her er en hjelpetekst"

        let disabledTextField = TextField(inputType: .normal)
        disabledTextField.translatesAutoresizingMaskIntoConstraints = false
        disabledTextField.placeholderText = "Disabled"
        disabledTextField.isEnabled = false

        let readOnlyTextField = TextField(state: .readOnly, inputType: .normal)
        readOnlyTextField.translatesAutoresizingMaskIntoConstraints = false
        readOnlyTextField.placeholderText = "Read only"
        readOnlyTextField.text = "Read only text!"

        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(normalTextField)
        addSubview(normalWithHelpTextTextField)
        addSubview(disabledTextField)
        addSubview(readOnlyTextField)

        NSLayoutConstraint.activate([
            normalTextField.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            normalTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            normalTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            emailTextField.topAnchor.constraint(equalTo: normalTextField.bottomAnchor, constant: .mediumLargeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .mediumLargeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            normalWithHelpTextTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: .mediumLargeSpacing),
            normalWithHelpTextTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            normalWithHelpTextTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            disabledTextField.topAnchor.constraint(equalTo: normalWithHelpTextTextField.bottomAnchor, constant: .mediumLargeSpacing),
            disabledTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            disabledTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            readOnlyTextField.topAnchor.constraint(equalTo: disabledTextField.bottomAnchor, constant: .mediumLargeSpacing),
            readOnlyTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            readOnlyTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
