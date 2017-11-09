//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class TroikaTextField: UIView {

    // MARK: - Internal properties

    private lazy var typeLabel: Label = {
        let label = Label(style: .detail(.stone))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var passwordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "view")
        imageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        return imageView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.body
        textField.textColor = .licorice
        textField.tintColor = .primaryBlue
        textField.delegate = self
        textField.rightView = passwordImageView
        return textField
    }()

    private let underlineHeight: CGFloat = 2
    private let animationDuration: Double = 0.4

    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = .stone
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - External properties

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        addSubview(typeLabel)
        addSubview(textField)
        addSubview(underline)
    }

    // MARK: - Superclass Overrides

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        typeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true

        textField.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: .mediumSpacing).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        underline.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        underline.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        underline.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: .mediumSpacing).isActive = true
        underline.heightAnchor.constraint(equalToConstant: underlineHeight).isActive = true
        underline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    // MARK: - Dependency injection

    public var presentable: TroikaTextFieldPresentable? {
        didSet {
            typeLabel.text = presentable?.type.typeText
            textField.isSecureTextEntry = (presentable?.type.isSecureMode)!
            textField.rightView?.isHidden = (presentable?.type.isSecureMode)!
            textField.placeholder = presentable?.type.placeHolder
        }
    }
}

// MARK: - UITextFieldDelegate

extension TroikaTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: animationDuration) {
            self.underline.backgroundColor = .secondaryBlue
        }
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: animationDuration) {
            self.underline.backgroundColor = .stone
        }
    }
}

public enum TextFieldType {
    case normal
    case email
    case password

    var typeText: String {
        switch self {
        case .normal: return "Skriv:"
        case .email: return "E-post:"
        case .password: return "Passord:"
        }
    }

    var placeHolder: String {
        switch self {
        case .normal: return "Et eller annet"
        case .email: return "E-post"
        case .password: return "Passord"
        }
    }

    var isSecureMode: Bool {
        switch self {
        case .password: return true
        default: return false
        }
    }
}
