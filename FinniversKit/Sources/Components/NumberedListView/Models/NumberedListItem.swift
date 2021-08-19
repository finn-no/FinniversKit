import Foundation

public protocol NumberedListItem {
    var title: String? { get }
    var body: String { get }
    var actionButtonTitle: String? { get }
}
