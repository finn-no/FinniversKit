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

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.body
        textField.textColor = .licorice
        return textField
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
    }

    // MARK: - Superclass Overrides

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        typeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }

    // MARK: - Dependency injection

    // MARK: - Private
}

public extension TroikaTextField {
    enum TextFieldType {
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

        //        var
    }
}
