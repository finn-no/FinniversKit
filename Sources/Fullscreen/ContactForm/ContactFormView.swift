//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class ContactFormView: UIView {
    private lazy var scrollView = UIScrollView(withAutoLayout: true)
    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        return label
    }()

    private lazy var detailTextLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        return label
    }()

    private lazy var accessoryLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        return label
    }()

    private lazy var nameTextField: TextField = {
        let textField = TextField(inputType: .normal)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var emailTextField: TextField = {
        let textField = TextField(inputType: .email)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var showPhoneCheckbox: Checkbox = {
        let checkbox = Checkbox(withAutoLayout: true)
        checkbox.title = "Check Box Title"
        checkbox.delegate = self
        return checkbox
    }()

    private lazy var phoneTextField: TextField = {
        let textField = TextField(inputType: .normal)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var submitButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    func configure(with viewModel: ContactFormViewModel) {
    }

    private func setup() {

    }

    // MARK: - Action

    @objc private func submit() {
    }
}

// MARK: - TextFieldDelegate

extension ContactFormView: TextFieldDelegate {
    public func textFieldShouldReturn(_ textField: TextField) -> Bool {
        return true
    }

    public func textFieldDidChange(_ textField: TextField) {
        if nameTextField.text?.isEmpty == true || emailTextField.text?.isEmpty == true {
            submitButton.isEnabled = false
        } else {
            submitButton.isEnabled = true
        }
    }
}

// MARK: - CheckboxDelegate

extension ContactFormView: CheckboxDelegate {
    public func checkbox(_ checkbox: Checkbox, didSelectItem item: CheckboxItem) {

    }

    public func checkbox(_ checkbox: Checkbox, didUnselectItem item: CheckboxItem) {

    }
}
