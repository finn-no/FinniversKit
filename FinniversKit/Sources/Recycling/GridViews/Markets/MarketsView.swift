import UIKit

public protocol MarketsView: UIView {
    func reloadData()
    func calculateSize(constrainedTo width: CGFloat) -> CGSize
}

public protocol MarketsViewDelegate: AnyObject {
    func marketsView(_ marketsGridView: MarketsView, didSelectItemAtIndex index: Int)
}

public protocol MarketsViewDataSource: AnyObject {
    func numberOfItems(inMarketsView marketsView: MarketsView) -> Int
    func marketsView(_ marketsView: MarketsView, modelAtIndex index: Int) -> MarketsViewModel
}
