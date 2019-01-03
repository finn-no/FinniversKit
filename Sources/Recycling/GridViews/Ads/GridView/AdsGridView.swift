//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdsGridViewDelegate: class {
    func adsGridViewDidStartRefreshing(_ adsGridView: AdsGridView)
    func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int)
    func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int)
    func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView)
    func adsGridView(_ adsGridView: AdsGridView, didSelectFavoriteButton button: UIButton, on cell: AdsGridViewCell, at index: Int)
}

public protocol AdsGridViewDataSource: class {
    func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int
    func adsGridView(_ adsGridView: AdsGridView, modelAtIndex index: Int) -> AdsGridViewModel
    func adsGridView(_ adsGridView: AdsGridView, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func adsGridView(_ adsGridView: AdsGridView, cancelLoadingImageForModel model: AdsGridViewModel, imageWidth: CGFloat)
}

public class AdsGridView: UIView {
    // MARK: - Internal properties

    private lazy var collectionViewLayout: AdsGridViewLayout = {
        return AdsGridViewLayout(delegate: self)
    }()

    // Have the collection view be private so nobody messes with it.
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .milk
        return collectionView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = RefreshControl(frame: .zero)
        refreshControl.delegate = self
        return refreshControl
    }()

    private weak var delegate: AdsGridViewDelegate?
    private weak var dataSource: AdsGridViewDataSource?

    // MARK: - External properties

    public var headerView: UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
    }

    // MARK: - Setup

    public init(delegate: AdsGridViewDelegate, dataSource: AdsGridViewDataSource) {
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
        collectionView.register(AdsGridViewCell.self)
        collectionView.register(AdsGridHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        addSubview(collectionView)
        collectionView.fillInSuperview()

        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }

    public func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Public

    public func reloadData() {
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }

    public func updateItem(at index: Int, isFavorite: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? AdsGridViewCell {
            cell.isFavorite = isFavorite
        }
    }

    public func scrollToTop(animated: Bool = true) {
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension AdsGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.adsGridView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.adsGridView(self, didScrollInScrollView: scrollView)
    }
}

// MARK: - UICollectionViewDataSource

extension AdsGridView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inAdsGridView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(AdsGridViewCell.self, for: indexPath)

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        cell.index = indexPath.row
        cell.loadingColor = color
        cell.dataSource = self
        cell.delegate = self

        if let model = dataSource?.adsGridView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? AdsGridViewCell {
            cell.loadImage()
        }

        delegate?.adsGridView(self, willDisplayItemAtIndex: indexPath.row)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let headerView = headerView else {
            fatalError("Suplementary view of kind '\(kind)' not supported.")
        }

        let header = collectionView.dequeue(AdsGridHeaderView.self, for: indexPath, ofKind: UICollectionView.elementKindSectionHeader)
        header.contentView = headerView

        return header
    }
}

// MARK: - AdsGridViewCellDataSource

extension AdsGridView: AdsGridViewCellDataSource {
    public func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.adsGridView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    public func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, cancelLoadingImageForModel model: AdsGridViewModel, imageWidth: CGFloat) {
        dataSource?.adsGridView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}

// MARK: - AdsGridViewDelegate

extension AdsGridView: AdsGridViewCellDelegate {
    public func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, didSelectFavoriteButton button: UIButton) {
        guard let index = adsGridViewCell.index else { return }
        delegate?.adsGridView(self, didSelectFavoriteButton: button, on: adsGridViewCell, at: index)
    }
}

// MARK: - AdsGridViewLayoutDelegate

extension AdsGridView: AdsGridViewLayoutDelegate {
    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, heightForHeaderViewInCollectionView collectionView: UICollectionView) -> CGFloat? {
        return headerView?.frame.size.height
    }

    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, imageHeightRatioForItemAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        guard let model = dataSource?.adsGridView(self, modelAtIndex: indexPath.row), model.imageSize != .zero, model.imagePath != nil else {
            let defaultImageSize = CGSize(width: 104, height: 78)
            return defaultImageSize.height / defaultImageSize.width
        }

        return model.imageSize.height / model.imageSize.width
    }

    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, itemNonImageHeightForItemAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        return AdsGridViewCell.nonImageHeight
    }
}

// MARK: - RefreshControlDelegate

extension AdsGridView: RefreshControlDelegate {
    public func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl) {
        delegate?.adsGridViewDidStartRefreshing(self)
    }
}
