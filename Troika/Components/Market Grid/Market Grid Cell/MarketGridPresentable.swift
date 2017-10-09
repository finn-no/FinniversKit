import Foundation

public protocol MarketGridPresentable {
    var iconImage: UIImage? { get }
    var showExternalLinkIcon: Bool { get }
    var title: String { get }
    var accessibilityLabel: String { get }
}

public extension MarketGridPresentable {
    var accessibilityLabel: String {
        return title
    }
}
