//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class ContactFormView: UIView {
    private lazy var scrollView = UIScrollView(withAutoLayout: true)
    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .title3
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailTextLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var accessoryLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detail
        label.textColor = .licorice
        label.numberOfLines = 0
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

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    public func configure(with viewModel: ContactFormViewModel) {
        titleLabel.text = viewModel.title
        detailTextLabel.text = viewModel.detailText
        accessoryLabel.text = viewModel.accessoryText
        nameTextField.placeholderText = viewModel.namePlaceholder
        emailTextField.placeholderText = viewModel.emailPlaceholder
        showPhoneCheckbox.title = viewModel.showPhoneCheckboxQuestion
        showPhoneCheckbox.fields = [viewModel.showPhoneCheckboxAnswer]
        phoneTextField.placeholderText = viewModel.phonePlaceholder
        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
    }

    private func setup() {
        backgroundColor = .milk

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(detailTextLabel)
        contentView.addSubview(accessoryLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(showPhoneCheckbox)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(submitButton)

        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .largeSpacing),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.largeSpacing),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .largeSpacing),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -.largeSpacing),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.veryLargeSpacing),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            detailTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .largeSpacing),
            detailTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            accessoryLabel.topAnchor.constraint(equalTo: detailTextLabel.bottomAnchor, constant: .mediumLargeSpacing),
            accessoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            nameTextField.topAnchor.constraint(equalTo: accessoryLabel.bottomAnchor, constant: .mediumLargeSpacing),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: .mediumLargeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            showPhoneCheckbox.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .veryLargeSpacing),
            showPhoneCheckbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showPhoneCheckbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            phoneTextField.topAnchor.constraint(equalTo: showPhoneCheckbox.bottomAnchor),
            phoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            submitButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: .veryLargeSpacing),
            submitButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            submitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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
