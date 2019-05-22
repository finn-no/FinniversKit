//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol ContactFormViewDelegate: AnyObject {
    func contactFormView(_ view: ContactFormView, didSubmitWithName name: String, email: String, phoneNumber: String)
}

public final class ContactFormView: UIView {
    public weak var delegate: ContactFormViewDelegate?

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

    private lazy var showPhoneNumberCheckbox: ContactFormCheckbox = {
        let checkbox = ContactFormCheckbox(withAutoLayout: true)
        checkbox.delegate = self
        return checkbox
    }()

    private lazy var phoneNumberTextField: TextField = {
        let textField = TextField(inputType: .phoneNumber)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        textField.delegate = self
        return textField
    }()

    private lazy var submitButton: Button = {
        let button = Button(style: .callToAction)
        button.isEnabled = false
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
        showPhoneNumberCheckbox.configure(
            question: viewModel.showPhoneNumberQuestion,
            answer: viewModel.showPhoneNumberAnswer
        )
        phoneNumberTextField.placeholderText = viewModel.phoneNumberPlaceholder
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
        contentView.addSubview(showPhoneNumberCheckbox)

        let bottomStackView = UIStackView(arrangedSubviews: [phoneNumberTextField, submitButton])
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .vertical
        bottomStackView.spacing = .largeSpacing

        contentView.addSubview(bottomStackView)
        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .largeSpacing),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.largeSpacing),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .mediumLargeSpacing),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -.mediumLargeSpacing),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.largeSpacing),

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

            showPhoneNumberCheckbox.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .largeSpacing),
            showPhoneNumberCheckbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showPhoneNumberCheckbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            bottomStackView.topAnchor.constraint(equalTo: showPhoneNumberCheckbox.bottomAnchor, constant: .mediumSpacing),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Action

    @objc private func submit() {
        guard let name = nameTextField.text, let email = emailTextField.text, let phoneNumber = phoneNumberTextField.text else {
            return
        }

        delegate?.contactFormView(self, didSubmitWithName: name, email: email, phoneNumber: phoneNumber)
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

// MARK: - ContactFormCheckboxDelegate

extension ContactFormView: ContactFormCheckboxDelegate {
    func contactFormCheckbox(_ checkbox: ContactFormCheckbox, didChangeSelection isSelected: Bool) {
        phoneNumberTextField.isHidden = !isSelected
    }
}
