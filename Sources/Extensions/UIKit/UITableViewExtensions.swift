//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension UITableViewCell: Identifiable {}

extension UITableViewHeaderFooterView: Identifiable {}

public extension UITableView {
    public func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    public func register(_ headerFooterClass: UITableViewHeaderFooterView.Type) {
        register(headerFooterClass.self, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseIdentifier)
    }

    public func registerNib(_ cellClass: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: cellClass), bundle: nil), forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    public func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }

    public func dequeue<T>(_ headerFooterClass: T.Type) -> T where T: UITableViewHeaderFooterView {
        return dequeueReusableHeaderFooterView(withIdentifier: headerFooterClass.reuseIdentifier) as! T
    }
}
