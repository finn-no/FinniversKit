//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol ContactFormViewDelegate: AnyObject {
    func contactFormView(_ view: ContactFormView, didSubmitWithName name: String, email: String, phoneNumber: String?)
}

public final class ContactFormView: UIView {
    public weak var delegate: ContactFormViewDelegate?
    private let notificationCenter = NotificationCenter.default

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
        textField.textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var emailTextField: TextField = {
        let textField = TextField(inputType: .email)
        textField.textField.returnKeyType = .next
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
        textField.textField.returnKeyType = .send
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

    public var isValid: Bool {
        let isValidName = nameTextField.isValidAndNotEmpty
        let isValidEmail = emailTextField.isValidAndNotEmpty
        let isValidPhoneNumber = phoneNumberTextField.isHidden || phoneNumberTextField.isValidAndNotEmpty

        return isValidName && isValidEmail && isValidPhoneNumber
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addObserverForKeyboardNotifications()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        addObserverForKeyboardNotifications()
    }

    deinit {
        notificationCenter.removeObserver(self)
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        backgroundColor = .milk

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(detailTextLabel)
        contentView.addSubview(accessoryLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(showPhoneNumberCheckbox)

        let bottomStackView = UIStackView(arrangedSubviews: [phoneNumberTextField])
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .vertical

        contentView.addSubview(bottomStackView)
        contentView.addSubview(submitButton)
        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .largeSpacing),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.mediumLargeSpacing),
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

            submitButton.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: .largeSpacing),
            submitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func handleTap() {
        endEditing(true)
    }

    @objc private func submit() {
        guard let name = nameTextField.text, let email = emailTextField.text else {
            return
        }

        let phoneNumber = phoneNumberTextField.isHidden ? nil : phoneNumberTextField.text

        if isValid {
            delegate?.contactFormView(self, didSubmitWithName: name, email: email, phoneNumber: phoneNumber)
        }
    }

    private func scrollToBottom(animated: Bool) {
        let yOffset = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom
        if yOffset > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        }
    }

    // MARK: - Keyboard notifications

    private func addObserverForKeyboardNotifications() {
        addObserverForKeyboardNotification(named: UIResponder.keyboardWillHideNotification)
        addObserverForKeyboardNotification(named: UIResponder.keyboardWillShowNotification)
    }

    private func addObserverForKeyboardNotification(named name: NSNotification.Name) {
        notificationCenter.addObserver(self, selector: #selector(adjustScrollViewForKeyboard(_:)), name: name, object: nil)
    }

    @objc private func adjustScrollViewForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        var keyboardHeight = convert(keyboardValue.cgRectValue, from: window).height

        if #available(iOS 11.0, *) {
            keyboardHeight -= window?.safeAreaInsets.bottom ?? 0
        }

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            scrollView.contentOffset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollToBottom(animated: false)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}

// MARK: - TextFieldDelegate

extension ContactFormView: TextFieldDelegate {
    public func textFieldShouldReturn(_ textField: TextField) -> Bool {
        if textField == nameTextField {
            emailTextField.textField.becomeFirstResponder()
        } else if textField == emailTextField, !phoneNumberTextField.isHidden {
            phoneNumberTextField.textField.becomeFirstResponder()
        } else {
            textField.textField.resignFirstResponder()
        }

        return true
    }

    public func textFieldDidChange(_ textField: TextField) {
        submitButton.isEnabled = isValid
    }
}

// MARK: - ContactFormCheckboxDelegate

extension ContactFormView: ContactFormCheckboxDelegate {
    func contactFormCheckbox(_ checkbox: ContactFormCheckbox, didChangeSelection isSelected: Bool) {
        phoneNumberTextField.textField.text = nil

        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.phoneNumberTextField.isHidden = !isSelected
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.submitButton.isEnabled = self.isValid
            self.scrollToBottom(animated: true)
        })
    }
}
