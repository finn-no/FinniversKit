//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoritesListViewDelegate: NSObjectProtocol {
    func favoritesListView(_ favoritesListView: FavoritesListView, didSelectItemAtIndex index: Int)
    func favoritesListView(_ favoritesListView: FavoritesListView, willDisplayItemAtIndex index: Int)
    func favoritesListView(_ favoritesListView: FavoritesListView, didScrollInScrollView scrollView: UIScrollView)
}

public protocol FavoritesListViewDataSource: NSObjectProtocol {
    func numberOfItems(inFavoritesListView favoritesListView: FavoritesListView) -> Int
    func favoritesListView(_ favoritesListView: FavoritesListView, modelAtIndex index: Int) -> FavoritesListViewModel
    func favoritesListView(_ favoritesListView: FavoritesListView, loadImageForModel model: FavoritesListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func favoritesListView(_ favoritesListView: FavoritesListView, cancelLoadingImageForModel model: FavoritesListViewModel, imageWidth: CGFloat)
}

public class FavoritesListView: UIView {
    public static let estimatedRowHeight: CGFloat = 106.0

    // MARK: - Internal properties

    // Have the collection view be private so nobody messes with it.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoritesListView.estimatedRowHeight
        tableView.estimatedRowHeight = FavoritesListView.estimatedRowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()

    private weak var delegate: FavoritesListViewDelegate?
    private weak var dataSource: FavoritesListViewDataSource?

    // MARK: - Setup

    public init(delegate: FavoritesListViewDelegate, dataSource: FavoritesListViewDataSource) {
        super.init(frame: .zero)

        self.delegate = delegate
        self.dataSource = dataSource

        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        tableView.register(FavoritesListViewCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Public

    public func reloadData() {
        tableView.reloadData()
    }

    public func scrollToTop(animated: Bool = true) {
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favoritesListView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.favoritesListView(self, didScrollInScrollView: scrollView)
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inFavoritesListView: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoritesListViewCell.self, for: indexPath)

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        cell.loadingColor = color
        cell.dataSource = self

        if let model = dataSource?.favoritesListView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FavoritesListViewCell {
            cell.loadImage()
        }

        delegate?.favoritesListView(self, willDisplayItemAtIndex: indexPath.row)
    }
}

// MARK: - FavoritesListViewCellDataSource

extension FavoritesListView: FavoritesListViewCellDataSource {
    public func favoritesListViewCell(_ favoritesListViewCell: FavoritesListViewCell, loadImageForModel model: FavoritesListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.favoritesListView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    public func favoritesListViewCell(_ favoritesListViewCell: FavoritesListViewCell, cancelLoadingImageForModel model: FavoritesListViewModel, imageWidth: CGFloat) {
        dataSource?.favoritesListView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}

