import Foundation

enum PreviewGridLayoutConfiguration {
    case small
    case medium
    case large

    static let mediumWidth: CGFloat = 375.0

    init(width: CGFloat) {
        switch width {
        case let width where width > PreviewGridLayoutConfiguration.mediumWidth: self = .large
        case let width where width < PreviewGridLayoutConfiguration.mediumWidth: self = .small
        default: self =  .medium
        }
    }

    var topOffset: CGFloat {
        switch self {
        case .large: return 10.0
        default: return 5.0
        }
    }

    var sidePadding: CGFloat {
        switch self {
        case .small:  return 10.0
        case .medium: return 15.0
        case .large:  return 25.0
        }
    }

    var lineSpacing: CGFloat {
        switch self {
        case .small:  return 0.0
        default: return columnSpacing
        }
    }

    var columnSpacing: CGFloat {
        switch self {
        case .small:  return 2.0
        case .medium: return 8.0
        case .large:  return 5.0
        }
    }

    var numberOfColumns: Int {
        switch self {
        case .large:
            let isLandscape = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
            return isLandscape ? 6 : 5

        default: return 2
        }
    }
}
