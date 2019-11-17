import Foundation

public protocol BasicTableViewCellViewModel {
    var title: String { get }
    var subtitle: String? { get }
    var detailText: String? { get }
    var hasChevron: Bool { get }
}
