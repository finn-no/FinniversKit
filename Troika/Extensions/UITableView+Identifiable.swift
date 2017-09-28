import UIKit

extension UITableViewCell: Identifiable {}

public extension UITableView {
    
    public func register(_ cellClass: UITableViewCell.Type) {
        self.register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func registerNib(_ cellClass: UITableViewCell.Type) {
        self.register(UINib.init(nibName: String(describing: cellClass), bundle: nil), forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }
}
