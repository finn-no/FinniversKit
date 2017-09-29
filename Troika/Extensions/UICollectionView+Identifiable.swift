import UIKit

extension UICollectionViewCell: Identifiable {}

public extension UICollectionView {
    
    public func register(_ cellClass: UICollectionViewCell.Type) {
        self.register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func registerNib(_ cellClass: UICollectionViewCell.Type) {
        self.register(UINib.init(nibName: String(describing: cellClass), bundle: nil), forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }
}
