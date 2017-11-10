//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Button: UIButton {

    // MARK: - Internal properties

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
    }

    // MARK: - Superclass Overrides

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel?.font = .title4
    }

    // MARK: - Dependency injection

    public var presentable: ButtonPresentable? {
        didSet {
            guard let presentable = presentable else {
                return
            }
            accessibilityLabel = presentable.title
            titleLabel?.textColor = presentable.type.textColor
            layer.borderColor = presentable.type.borderColor.cgColor
            backgroundColor = presentable.type.bodyColor
        }
    }

    // MARK: - Private

    public var typeOfButton: ButtonType?
}

public extension Button {

    public enum ButtonType {
        case normal // default
        case flat
        case destructive

        var bodyColor: UIColor {
            switch self {
            case .normal: return .milk
            case .flat: return .primaryBlue
            case .destructive: return .cherry
            }
        }

        var borderColor: UIColor {
            switch self {
            case .normal: return .secondaryBlue
            case .flat: return .primaryBlue
            case .destructive: return .cherry
            }
        }

        var textColor: UIColor {
            switch self {
            case .normal: return .primaryBlue
            default: return .milk
            }
        }
    }
}
