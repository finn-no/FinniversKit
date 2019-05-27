//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - TextFieldDelegate

public protocol TextFieldDelegate: class {
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
    private let errorImage = UIImage(named: .error)
    private let rightViewSize = CGSize(width: 40, height: 40)
    private let animationDuration: Double = 0.3
    private let errorIconWidth: CGFloat = 18

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
        button.imageView?.tintColor = .stone
        button.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        return button
    }()

    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: eyeImage.size.width, height: eyeImage.size.width))
        button.setImage(eyeImage, for: .normal)
        button.imageView?.tintColor = .stone
        button.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        return button
    }()

    private lazy var multilineDisclosureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: eyeImage.size.width, height: eyeImage.size.width))
        button.setImage(multilineDisclosureIcon, for: .normal)
        button.imageView?.tintColor = .stone
        button.addTarget(self, action: #selector(multilineDisclusureTapped), for: .touchUpInside)
        return button
    }()

    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ice
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = .stone
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
        textField.textColor = .licorice
        textField.tintColor = .secondaryBlue
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()

    public let inputType: InputType
    public var phoneNumberRegEx = "^(?:\\s*\\d){8,11}$"

    public var placeholderText: String = "" {
        didSet {
            typeLabel.text = placeholderText
            accessibilityLabel = placeholderText
            textField.placeholder = placeholderText
        }
    }

    public var text: String? {
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var helpText: String? {
        didSet {
            helpTextLabel.text = helpText
        }
    }

    public weak var delegate: TextFieldDelegate?

    public var isValid: Bool {
        guard let text = text else {
            return false
        }

        switch inputType {
        case .password:
            return isValidPassword(text)
        case .email:
            return isValidEmail(text)
        case .phoneNumber:
            return isValidPhoneNumber(text)
        case .normal, .multiline:
            return true
        }
    }

    public var isValidAndNotEmpty: Bool {
        return text?.isEmpty == false && isValid
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

        if inputType == .email || inputType == .phoneNumber {
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

            textFieldBackgroundView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: .smallSpacing),
            textFieldBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor, constant: .mediumSpacing + .smallSpacing),
            textField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: .mediumSpacing),
            textField.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: -.mediumSpacing),
            textField.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor, constant: -.mediumSpacing + -.smallSpacing),

            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor),

            errorIconImageView.topAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor, constant: .smallSpacing),
            errorIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            helpTextLabel.topAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor, constant: .smallSpacing),
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
            sender.imageView?.tintColor = .secondaryBlue
            textField.isSecureTextEntry = false
        } else {
            sender.imageView?.tintColor = .stone
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

    fileprivate func evaluate(_ regEx: String, with string: String) -> Bool {
        let regExTest = NSPredicate(format: "SELF MATCHES %@", regEx)
        return regExTest.evaluate(with: string)
    }

    fileprivate func isValidEmail(_ emailAdress: String) -> Bool {
        return evaluate("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", with: emailAdress)
    }

    fileprivate func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        return evaluate(phoneNumberRegEx, with: phoneNumber)
    }

    fileprivate func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty
    }

    fileprivate func shouldDisplayErrorHelpText() -> Bool {
        guard state == .error else {
            return false
        }

        guard let helpText = helpText, helpText.count > 0 else {
            return false
        }

        return true
    }

    private func transition(to state: State) {
        layoutIfNeeded()
        underlineHeightConstraint?.constant = state.underlineHeight

        if inputType == .email || inputType == .phoneNumber {
            if shouldDisplayErrorHelpText() {
                helpTextLabelLeadingConstraint?.constant = errorIconImageView.frame.size.width + .smallSpacing
            } else {
                helpTextLabelLeadingConstraint?.constant = 0.0
            }
        }

        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
            self.underline.backgroundColor = state.underlineColor
            self.textFieldBackgroundView.backgroundColor = state.textFieldBackgroundColor
            self.typeLabel.textColor = state.accessoryLabelTextColor
            self.helpTextLabel.textColor = state.accessoryLabelTextColor

            if self.inputType == .email || self.inputType == .phoneNumber {
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

        if let text = text, !text.isEmpty, !isValid {
            state = .error
        } else {
            state = .normal
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
