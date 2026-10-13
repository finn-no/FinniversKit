//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension UITableViewCell: Identifiable {}

extension UITableViewHeaderFooterView: Identifiable {}

public extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func register(_ headerFooterClass: UITableViewHeaderFooterView.Type) {
        register(headerFooterClass.self, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseIdentifier)
    }

    func registerNib(_ cellClass: UITableViewCell.Type, bundle: Bundle? = nil) {
        register(UINib(nibName: String(describing: cellClass), bundle: bundle), forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }

    func dequeue<T>(_ headerFooterClass: T.Type) -> T where T: UITableViewHeaderFooterView {
        // swiftlint:disable:next force_cast
        return dequeueReusableHeaderFooterView(withIdentifier: headerFooterClass.reuseIdentifier) as! T
    }

    func stopScrolling() {
        setContentOffset(contentOffset, animated: false)
    }
}

extension UITableView {
    var isScrolling: Bool {
        isTracking || isDragging || isDecelerating
    }

    func firstFullyVisibleCell(where isIncluded: (IndexPath) -> Bool) -> UITableViewCell? {
        let visibleRect = bounds.inset(by: adjustedContentInset)
        return (indexPathsForVisibleRows ?? [])
            .sorted()
            .lazy
            .filter(isIncluded)
            .compactMap { self.cellForRow(at: $0) }
            .first { visibleRect.contains($0.frame) }
    }
}
