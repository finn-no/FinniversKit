//
//  Copyright © FINN.no AS. All rights reserved.
//

public extension QuestionnaireView {
    enum Style {
        case normal(backgroundColor: UIColor, primaryButtonIcon: UIImage?)

        var titleStyle: Label.Style {
            switch self {
            case .normal:
                return .detail
            }
        }

        var detailStyle: Label.Style {
            switch self {
            case .normal:
                return .bodyStrong
            }
        }

        var primaryButtonStyle: Button.Style {
            switch self {
            case .normal:
                return .default
            }
        }

        var primaryButtonSize: Button.Size {
            switch self {
            case .normal:
                return .normal
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .normal(let backgroundColor, _):
                return backgroundColor
            }
        }

        var primaryButtonIcon: UIImage? {
            switch self {
            case .normal(_, let image):
                return image
            }
        }
    }
}
