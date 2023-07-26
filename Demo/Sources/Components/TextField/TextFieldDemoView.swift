//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit
import DemoKit

public class TextFieldDemoView: UIView, Demoable {

    // MARK: - Private properties

    private lazy var stackView = UIStackView.init(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

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

        let overrideBgColor = TextField(inputType: .normal)
        overrideBgColor.translatesAutoresizingMaskIntoConstraints = false
        overrideBgColor.placeholderText = "Overridden bgColor"
        overrideBgColor.configure(textFieldBackgroundColor: .bgPrimary)
        overrideBgColor.configureBorder(radius: 4, width: 1, color: .borderDefault)

        stackView.addArrangedSubviews([
            emailTextField,
            passwordTextField,
            normalTextField,
            normalWithHelpTextTextField,
            multilineTextField,
            overrideBgColor,
        ])
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}
