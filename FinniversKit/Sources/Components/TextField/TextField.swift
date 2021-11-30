//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - TextFieldDelegate

public protocol TextFieldDelegate: AnyObject {
    func textFieldDidBeginEditing(_ textField: TextField)
    func textFieldDidEndEditing(_ textField: TextField)
    func textFieldShouldReturn(_ textField: TextField) -> Bool
    func textField(_ textField: TextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldDidChange(_ textField: TextField)
    func textFieldDidTapMultilineAction(_ textField: TextField)
}

public extension TextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: TextField) {
        // Default empty implementation
    }

    func textFieldDidEndEditing(_ textField: TextField) {
        // Default empty implementation
    }

    func textFieldShouldReturn(_ textField: TextField) -> Bool {
        return true
    }

    func textField(_ textField: TextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldDidChange(_ textField: TextField) {
        // Default empty implementation
    }

    func textFieldDidTapMultilineAction(_ textField: TextField) {
        // Default empty implementation
    }
}

public class TextField: UIView {
    // MARK: - Internal properties

    private let eyeImage = UIImage(named: .view).withRenderingMode(.alwaysTemplate)
    private let clearTextIcon = UIImage(named: .remove).withRenderingMode(.alwaysTemplate)
    private let multilineDisclosureIcon = UIImage(named: .remove).withRenderingMode(.alwaysTemplate)
    private let errorImage = UIImage(named: .exclamationMarkTriangleMini)
    private let rightViewSize = CGSize(width: 40, height: 40)
    private let animationDuration: Double = 0.3
    private let errorIconWidth: CGFloat = 16

    private var underlineHeightConstraint: NSLayoutConstraint?
    private var helpTextLabelLeadingConstraint: NSLayoutConstraint?

    private var state: State = .normal {
        didSet {
            transition(to: state)
        }
    }

    private lazy var typeLabel: Label = {
        let label = Label(style: .captionStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: clearTextIcon.size.width, height: clearTextIcon.size.height))
        button.setImage(clearTextIcon, for: .normal)
        button.imageView?.tintColor = .textSecondary //DARK
        button.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        return button
    }()

    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: eyeImage.size.width, height: eyeImage.size.width))
        button.setImage(eyeImage, for: .normal)
        button.imageView?.tintColor = .textSecondary //DARK
        button.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        return button
    }()

    private lazy var multilineDisclosureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: eyeImage.size.width, height: eyeImage.size.width))
        button.setImage(multilineDisclosureIcon, for: .normal)
        button.imageView?.tintColor = .textSecondary //DARK
        button.addTarget(self, action: #selector(multilineDisclusureTapped), for: .touchUpInside)
        return button
    }()

    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .bgSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = .textSecondary //DARK
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var helpTextLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var errorIconImageView: UIImageView = {
        let imageView = UIImageView(image: errorImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - External properties

    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.body
        textField.textColor = .textPrimary
        textField.tintColor = .accentSecondaryBlue //DARK
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.adjustsFontForContentSizeCategory = true

        return textField
    }()

    public let inputType: InputType
    public let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    public var phoneNumberRegEx = "^(?:\\s*\\d){8,11}$"

    public var placeholderText: String = "" {
        didSet {
            typeLabel.text = placeholderText
            accessibilityLabel = placeholderText
            textField.placeholder = placeholderText //DARK could use attributedPlaceholder to set custom color of placeholder text
        }
    }

    public var text: String? {
        get {
            textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            textField.text = newValue
            evaluateCurrentTextState()
        }
    }

    public var helpText: String? {
        didSet {
            helpTextLabel.text = helpText
            evaluateCurrentTextState()
        }
    }

    public weak var delegate: TextFieldDelegate?

    public var isValid: Bool {
        guard let text = text else {
            return false
        }

        let isValidByInputType: Bool
        switch inputType {
        case .password:
            isValidByInputType = isValidPassword(text)
        case .email:
            isValidByInputType = isValidEmail(text)
        case .phoneNumber:
            isValidByInputType = isValidPhoneNumber(text)
        case .normal, .multiline:
            isValidByInputType = true
        }

        if isValidByInputType, let customValidator = customValidator {
            return customValidator(text)
        }
        return isValidByInputType
    }

    public var isValidAndNotEmpty: Bool {
        return text?.isEmpty == false && isValid
    }

    /// A custom validator method that validates after `InputType` validation.
    public var customValidator: ((String) -> Bool)? {
        didSet {
            evaluateCurrentTextState()
        }
    }

    // MARK: - Setup

    public init(inputType: InputType) {
        self.inputType = inputType
        super.init(frame: .zero)
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(inputType: .email)
    }

    private func setup() {
        isAccessibilityElement = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        textField.isSecureTextEntry = inputType.isSecureMode
        textField.keyboardType = inputType.keyBoardStyle
        textField.returnKeyType = inputType.returnKeyType
        textField.textContentType = inputType.textContentType

        switch inputType {
        case .password:
            textField.rightViewMode = .always
            textField.rightView = showPasswordButton

        case .multiline:
            textField.rightViewMode = .always
            textField.rightView = multilineDisclosureButton

        default:
            textField.rightViewMode = .whileEditing
            textField.rightView = clearButton
        }

        if isHelpTextForErrors() {
            // Help text shows on error only.
            helpTextLabel.alpha = 0.0
        }

        // Error image should not show until we are in an error state
        errorIconImageView.alpha = 0.0

        addSubview(typeLabel)
        addSubview(textFieldBackgroundView)
        addSubview(textField)
        addSubview(underline)
        addSubview(helpTextLabel)
        addSubview(errorIconImageView)

        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: topAnchor),

            textFieldBackgroundView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: .spacingXS),
            textFieldBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor, constant: .spacingS + .spacingXS),
            textField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: .spacingS),
            textField.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: -.spacingS),
            textField.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor, constant: -.spacingS + -.spacingXS),

            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor),

            errorIconImageView.topAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor, constant: .spacingXS),
            errorIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            helpTextLabel.topAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor, constant: .spacingXS),
            helpTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            helpTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        helpTextLabelLeadingConstraint = helpTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        helpTextLabelLeadingConstraint?.isActive = true

        underlineHeightConstraint = underline.heightAnchor.constraint(equalToConstant: State.normal.underlineHeight)
        underlineHeightConstraint?.isActive = true
    }

    // MARK: - Actions

    @objc private func showHidePassword(sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            sender.imageView?.tintColor = .accentSecondaryBlue //DARK
            textField.isSecureTextEntry = false
        } else {
            sender.imageView?.tintColor = .textSecondary //DARK
            textField.isSecureTextEntry = true
        }

        textField.becomeFirstResponder()
    }

    @objc private func clearTapped() {
        textField.text = ""
        textFieldDidChange()
    }

    @objc private func multilineDisclusureTapped(sender: UIButton) {
        delegate?.textFieldDidTapMultilineAction(self)
    }

    @objc private func textFieldDidChange() {
        delegate?.textFieldDidChange(self)
    }

    @objc private func handleTap() {
        textField.becomeFirstResponder()
    }

    // MARK: - Functionality

    private func evaluate(_ regEx: String, with string: String) -> Bool {
        let regExTest = NSPredicate(format: "SELF MATCHES %@", regEx)
        return regExTest.evaluate(with: string)
    }

    private func isValidEmail(_ emailAdress: String) -> Bool {
        return evaluate(emailRegEx, with: emailAdress)
    }

    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        return evaluate(phoneNumberRegEx, with: phoneNumber)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty
    }

    private func isHelpTextForErrors() -> Bool {
        if inputType == .email || inputType == .phoneNumber {
            return true
        }
        return customValidator != nil
    }

    private func shouldDisplayErrorHelpText() -> Bool {
        guard state == .error else {
            return false
        }

        guard let helpText = helpText, helpText.count > 0 else {
            return false
        }

        return true
    }

    private func evaluateCurrentTextState() {
        if let text = text, !text.isEmpty, !isValid {
            state = .error
        } else {
            state = .normal
        }
    }

    private func transition(to state: State) {
        layoutIfNeeded()
        underlineHeightConstraint?.constant = state.underlineHeight

        if isHelpTextForErrors() {
            if shouldDisplayErrorHelpText() {
                helpTextLabelLeadingConstraint?.constant = errorIconImageView.frame.size.width + .spacingXS
            } else {
                helpTextLabelLeadingConstraint?.constant = 0.0
            }
        } else {
            helpTextLabelLeadingConstraint?.constant = 0.0
            errorIconImageView.alpha = 0.0
        }

        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
            self.underline.backgroundColor = state.underlineColor
            self.textFieldBackgroundView.backgroundColor = state.textFieldBackgroundColor
            self.typeLabel.textColor = state.accessoryLabelTextColor
            self.helpTextLabel.textColor = state.accessoryLabelTextColor

            if self.isHelpTextForErrors() {
                if self.shouldDisplayErrorHelpText() {
                    self.helpTextLabel.alpha = 1.0
                    self.errorIconImageView.alpha = 1.0
                } else {
                    self.helpTextLabel.alpha = 0.0
                    self.errorIconImageView.alpha = 0.0
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension TextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch inputType {
        case .multiline:
            delegate?.textFieldDidTapMultilineAction(self)
            return false

        default: return true
        }
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(self)
        state = .focus
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self)

        evaluateCurrentTextState()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
