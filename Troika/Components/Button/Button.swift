//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Button: UIButton {

    // MARK: - Internal properties

    private let cornerRadius: CGFloat = 4.0

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

        titleLabel?.font = .title4
        layer.cornerRadius = cornerRadius
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
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

        var borderWidth: CGFloat {
            switch self {
            case .normal: return 2.0
            default: return 0.0
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
