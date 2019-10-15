//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdsGridViewDelegate: AnyObject {
    func adsGridViewDidStartRefreshing(_ adsGridView: AdsGridView)
    func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int)
    func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int)
    func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView)
    func adsGridView(_ adsGridView: AdsGridView, didSelectFavoriteButton button: UIButton, on cell: AdsGridViewCell, at index: Int)
}

public protocol AdsGridViewDataSource: AnyObject {
    func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int
    func adsGridView(_ adsGridView: AdsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type]
    func adsGridView(_ adsGridView: AdsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat
    func adsGridView(_ adsGridView: AdsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func adsGridView(_ adsGridView: AdsGridView, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((AdsGridViewModel, UIImage?) -> Void))
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
        collectionView.backgroundColor = .bgPrimary
        return collectionView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = RefreshControl(frame: .zero)
        refreshControl.delegate = self
        return refreshControl
    }()

    private weak var delegate: AdsGridViewDelegate?
    private weak var dataSource: AdsGridViewDataSource?
    private let imageCache = ImageMemoryCache()

    // MARK: - External properties

    public var headerView: UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
    }

    public var isRefreshEnabled = false {
        didSet {
            setupRefreshControl()
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
        let cellClasses = dataSource?.adsGridView(self, cellClassesIn: collectionView) ?? []

        cellClasses.forEach { cellClass in
            collectionView.register(cellClass)
        }

        collectionView.register(AdsGridHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    private func setupRefreshControl() {
        collectionView.refreshControl = isRefreshEnabled ? refreshControl : nil
    }

    public func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Public

    public func reloadData() {
        endRefreshing()
        collectionView.reloadData()
    }

    public func endRefreshing() {
        refreshControl.endRefreshing()
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
        guard let cell = dataSource?.adsGridView(self, collectionView: collectionView, cellForItemAt: indexPath) else {
            preconditionFailure("Data source not configured correctly")
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
    public func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, cachedImageForModel model: AdsGridViewModel) -> UIImage? {
        guard let imagePath = model.imagePath else {
            return nil
        }

        return imageCache.image(forKey: imagePath)
    }

    public func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((AdsGridViewModel, UIImage?) -> Void)) {
        dataSource?.adsGridView(self, loadImageForModel: model, imageWidth: imageWidth, completion: { [weak self] model, image in
            if let image = image, let imagePath = model.imagePath {
                self?.imageCache.add(image, forKey: imagePath)
            }

            completion(model, image)
        })
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

    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        return dataSource?.adsGridView(self, heightForItemWithWidth: width, at: indexPath) ?? 0
    }
}

// MARK: - RefreshControlDelegate

extension AdsGridView: RefreshControlDelegate {
    public func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl) {
        delegate?.adsGridViewDidStartRefreshing(self)
    }
}
