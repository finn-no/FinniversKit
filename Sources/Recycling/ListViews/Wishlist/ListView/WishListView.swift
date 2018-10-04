//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol WishListViewDelegate: NSObjectProtocol {
    func wishListView(_ wishListView: WishListView, didSelectItemAtIndex index: Int)
    func wishListView(_ wishListView: WishListView, willDisplayItemAtIndex index: Int)
    func wishListView(_ wishListView: WishListView, didScrollInScrollView scrollView: UIScrollView)
}

public protocol WishListViewDataSource: NSObjectProtocol {
    func numberOfItems(inWishListView wishListView: WishListView) -> Int
    func wishListView(_ wishListView: WishListView, modelAtIndex index: Int) -> WishListViewModel
    func wishListViewCell(_ wishlistListViewCell: WishListViewCell, loadImageForModel model: WishListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func wishListViewCell(_ wishlistListViewCell: WishListViewCell, cancelLoadingImageForModel model: WishListViewModel, imageWidth: CGFloat)
}

public class WishListView: UIView {
    public static let estimatedRowHeight: CGFloat = 300
    
    // MARK: - Internal properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = WishListView.estimatedRowHeight
        tableView.estimatedRowHeight = WishListView.estimatedRowHeight
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Public properties
    
    public weak var delegate: WishListViewDelegate?
    public weak var dataSource: WishListViewDataSource?
    
    // MARK: - Setup
    
    public init(delegate: WishListViewDelegate, dataSource: WishListViewDataSource) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.dataSource = dataSource
        
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        tableView.register(WishListViewCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
    public func insertRows(at indexPath: [IndexPath], with animation: UITableViewRowAnimation) {
        tableView.insertRows(at: indexPath, with: animation)
    }
    
    public func deleteRows(at indexPath: [IndexPath], with animation: UITableViewRowAnimation) {
        tableView.deleteRows(at: indexPath, with: animation)
    }
    
    public func scrollToTop(animated: Bool = true) {
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
    }
}

// MARK: - UITableViewDataSource

extension WishListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inWishListView: self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(WishListViewCell.self, for: indexPath)
        
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]
        
        cell.loadingColor = color
        cell.dataSource = self
        cell.model = dataSource?.wishListView(self, modelAtIndex: indexPath.row)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WishListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.wishListView(self, didSelectItemAtIndex: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? WishListViewCell {
            cell.loadImage()
        }
        
        delegate?.wishListView(self, willDisplayItemAtIndex: indexPath.row)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.wishListView(self, didScrollInScrollView: scrollView)
    }
}

// MARK: - WishListViewCellDataSource

extension WishListView: WishListViewCellDataSource {
    public func wishListViewCell(_ wishlistListViewCell: WishListViewCell, loadImageForModel model: WishListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.wishListViewCell(wishlistListViewCell, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }
    
    public func wishListViewCell(_ wishlistListViewCell: WishListViewCell, cancelLoadingImageForModel model: WishListViewModel, imageWidth: CGFloat) {
        dataSource?.wishListViewCell(wishlistListViewCell, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}
