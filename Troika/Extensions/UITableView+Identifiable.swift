import UIKit

extension UITableViewCell: Identifiable {}

public extension UITableView {

    public func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    public func registerNib(_ cellClass: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: cellClass), bundle: nil), forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    public func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }
}
