//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol GridPreviewListViewDelegate: NSObjectProtocol {
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, didSelectItemAtIndex index: Int)
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, willDisplayItemAtIndex index: Int)
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, didScrollInScrollView scrollView: UIScrollView)
}

public protocol GridPreviewListViewDataSource: NSObjectProtocol {
    func numberOfItems(inGridPreviewListView gridPreviewListView: GridPreviewListView) -> Int
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, modelAtIndex index: Int) -> GridPreviewListViewModel
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, loadImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, cancelLoadingImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat)
}

public class GridPreviewListView: UIView {

    // MARK: - Internal properties

    private lazy var collectionViewLayout: GridPreviewListViewLayout = {
        return GridPreviewListViewLayout(delegate: self)
    }()

    // Have the collection view be private so nobody messes with it.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private weak var delegate: GridPreviewListViewDelegate?
    private weak var dataSource: GridPreviewListViewDataSource?

    // MARK: - External properties

    public var headerView: UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
    }

    // MARK: - Setup

    public init(delegate: GridPreviewListViewDelegate, dataSource: GridPreviewListViewDataSource) {
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
        collectionView.register(GridPreviewCell.self, forCellWithReuseIdentifier: String(describing: GridPreviewCell.self))
        collectionView.register(GridPreviewHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: GridPreviewHeaderView.self))
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    public func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Public

    public func reloadData() {
        collectionView.reloadData()
    }

    public func scrollToTop(animated: Bool = true) {
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension GridPreviewListView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.gridPreviewListView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.gridPreviewListView(self, didScrollInScrollView: scrollView)
    }
}

// MARK: - UICollectionViewDataSource

extension GridPreviewListView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inGridPreviewListView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(GridPreviewCell.self, for: indexPath)

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        cell.loadingColor = color
        cell.dataSource = self

        if let model = dataSource?.gridPreviewListView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GridPreviewCell {
            cell.loadImage()
        }

        delegate?.gridPreviewListView(self, willDisplayItemAtIndex: indexPath.row)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader, let headerView = headerView else {
            fatalError("Suplementary view of kind '\(kind)' not supported.")
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: GridPreviewHeaderView.self), for: indexPath) as! GridPreviewHeaderView
        header.contentView = headerView

        return header
    }
}

// MARK: - GridPreviewCellDataSource

extension GridPreviewListView: GridPreviewCellDataSource {
    public func gridPreviewCell(_ gridPreviewCell: GridPreviewCell, loadImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.gridPreviewListView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    public func gridPreviewCell(_ gridPreviewCell: GridPreviewCell, cancelLoadingImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat) {
        dataSource?.gridPreviewListView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}

// MARK: - GridPreviewListViewLayoutDelegate

extension GridPreviewListView: GridPreviewListViewLayoutDelegate {
    func gridPreviewListViewLayout(_ gridPreviewListViewLayout: GridPreviewListViewLayout, heightForHeaderViewInCollectionView collectionView: UICollectionView) -> CGFloat? {
        return headerView?.frame.size.height
    }

    func gridPreviewListViewLayout(_ gridPreviewListViewLayout: GridPreviewListViewLayout, imageHeightRatioForItemAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        guard let model = dataSource?.gridPreviewListView(self, modelAtIndex: indexPath.row), model.imageSize != .zero, model.imagePath != nil else {
            let defaultImageSize = CGSize(width: 104, height: 78)
            return defaultImageSize.height / defaultImageSize.width
        }

        return model.imageSize.height / model.imageSize.width
    }

    func gridPreviewListViewLayout(_ gridPreviewListViewLayout: GridPreviewListViewLayout, itemNonImageHeightForItemAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        return GridPreviewCell.nonImageHeight
    }
}
