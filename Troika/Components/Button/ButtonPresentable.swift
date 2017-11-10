import Foundation

public protocol ButtonPresentable {
    var title: String { get }
    var type: ButtonType { get }
    var accessibilityLabel: String { get }
}

public extension ButtonPresentable {
    var accessibilityLabel: String {
        return title
    }
}

