import Foundation

public protocol ToastPresentable {
    var type: ToastType { get }
    var accessibilityLabel: String { get }
    var messageTitle: String { get }
}

public extension ToastPresentable {
    var accessibilityLabel: String {
        return messageTitle
    }
}
