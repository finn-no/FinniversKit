//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class Button: UIButton {

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
        // Perform setup
    }

    // MARK: - Superclass Overrides

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        // Add custom subviews
        // Layout your custom views
    }

    // MARK: - Dependency injection

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
