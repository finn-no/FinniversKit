//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TextFieldDelegate: NSObjectProtocol {
    func textFieldDidBeginEditing(_ textField: TextField)
    func textFieldDidEndEditing(_ textField: TextField)
    func textFieldShouldReturn(_ textField: TextField) -> Bool
    func textField(_ textField: TextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldDidChange(_ textField: TextField)
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
}

public class TextField: UIView {

    // MARK: - Internal properties

    private let eyeImage = UIImage(frameworkImageNamed: "view")!.withRenderingMode(.alwaysTemplate)
    private let clearTextIcon = UIImage(frameworkImageNamed: "remove")!.withRenderingMode(.alwaysTemplate)
    private let rightViewSize = CGSize(width: 40, height: 40)
    private let underlineHeight: CGFloat = 2
    private let animationDuration: Double = 0.3

    private lazy var typeLabel: Label = {
        let label = Label(style: .detail(.stone))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: rightViewSize.width, height: rightViewSize.height))
        button.setImage(clearTextIcon, for: .normal)
        button.imageView?.tintColor = .stone
        button.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        return button
    }()

    private lazy var showPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(eyeImage, for: .normal)
        button.imageView?.tintColor = .stone
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        return button
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.body
        textField.textColor = .licorice
        textField.tintColor = .secondaryBlue
        textField.delegate = self
        textField.rightViewMode = .whileEditing
        textField.rightView = clearButton
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()

    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = .stone
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - External properties

    public let inputType: InputType
    public var placeholderText: String = "" {
        didSet {
            typeLabel.text = placeholderText
            accessibilityLabel = placeholderText
            textField.placeholder = placeholderText
        }
    }

    public var text: String? {
        return textField.text
    }

    public weak var delegate: TextFieldDelegate?

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
        showPasswordButton.isHidden = !inputType.isSecureMode
        textField.keyboardType = inputType.keyBoardStyle
        textField.returnKeyType = inputType.returnKeyType

        if inputType.isSecureMode {
            textField.rightViewMode = .never
        }

        addSubview(typeLabel)
        addSubview(textField)
        addSubview(showPasswordButton)
        addSubview(underline)
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        typeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true

        textField.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: .mediumSpacing).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: showPasswordButton.leadingAnchor).isActive = true

        showPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        showPasswordButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        showPasswordButton.heightAnchor.constraint(equalToConstant: eyeImage.size.height).isActive = true

        if inputType.isSecureMode {
            showPasswordButton.widthAnchor.constraint(equalToConstant: rightViewSize.width).isActive = true
        } else {
            showPasswordButton.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }

        underline.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        underline.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        underline.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: .mediumSpacing).isActive = true
        underline.heightAnchor.constraint(equalToConstant: underlineHeight).isActive = true
        underline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        typeLabel.transform = transform.translatedBy(x: 0, y: typeLabel.frame.height)
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
    }

    @objc private func clearTapped() {
        textField.text = ""
        textFieldDidChange()
    }

    @objc private func textFieldDidChange() {
        delegate?.textFieldDidChange(self)

        if let text = textField.text, !text.isEmpty {
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.typeLabel.transform = CGAffineTransform.identity
                self.typeLabel.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.typeLabel.transform = self.typeLabel.transform.translatedBy(x: 0, y: self.typeLabel.frame.height)
                self.typeLabel.alpha = 0
            })
        }
    }

    @objc private func handleTap() {
        textField.becomeFirstResponder()
    }

    fileprivate func isValidEmail(_ emailAdress: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAdress)
    }
}

// MARK: - UITextFieldDelegate

extension TextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(self)
        UIView.animate(withDuration: animationDuration) {
            self.underline.backgroundColor = .secondaryBlue
        }
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self)
        if let text = textField.text, !isValidEmail(text), !text.isEmpty, inputType == .email {
            UIView.animate(withDuration: animationDuration) {
                self.underline.backgroundColor = .cherry
            }
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.underline.backgroundColor = .stone
            }
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
