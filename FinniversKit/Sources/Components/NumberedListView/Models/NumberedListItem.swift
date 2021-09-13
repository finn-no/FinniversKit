import Foundation

public protocol NumberedListItem {
    var heading: String? { get }
    var body: String { get }
    var actionButtonTitle: String? { get }
}
