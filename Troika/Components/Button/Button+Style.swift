//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Button {

    public enum Style {
        case normal // default
        case flat
        case destructive
        case link

        var bodyColor: UIColor {
            switch self {
            case .normal, .link: return .milk
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

        var borderColor: UIColor? {
            switch self {
            case .normal: return .secondaryBlue
            default: return nil
            }
        }

        var textColor: UIColor {
            switch self {
            case .normal, .link: return .primaryBlue
            default: return .milk
            }
        }

        var highlightedBodyColor: UIColor? {
            switch self {
            case .flat: return UIColor(red: 0 / 255, green: 79 / 255, blue: 201 / 255, alpha: 1.0) // #004fc9
            case .destructive: return UIColor(red: 201 / 255, green: 79 / 255, blue: 0 / 255, alpha: 1.0)
            default: return nil
            }
        }

        var highlightedBorderColor: UIColor? {
            switch self {
            case .normal: return .primaryBlue
            default: return nil
            }
        }

        var highlightedTextColor: UIColor? {
            switch self {
            case .link: return UIColor(red: 0 / 255, green: 79 / 255, blue: 201 / 255, alpha: 1.0) // #004fc9
            default: return nil
            }
        }

        var disabledBodyColor: UIColor? {
            switch self {
            case .normal, .link: return nil
            default: return .sardine
            }
        }

        var disabledBorderColor: UIColor? {
            switch self {
            case .normal: return .sardine
            default: return nil
            }
        }

        var disabledTextColor: UIColor? {
            switch self {
            case .flat, .destructive: return nil
            default: return .sardine
            }
        }
    }
}
