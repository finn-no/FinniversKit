//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdRecommendationsGridViewDelegate: AnyObject {
    func adsGridViewDidStartRefreshing(_ adsGridView: AdRecommendationsGridView)
    func adsGridView(_ adsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int)
    func adsGridView(_ adsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int)
    func adsGridView(_ adsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView)
    func adsGridView(_ adsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int)
}

public protocol AdsGridViewDataSource: AnyObject {
    func numberOfItems(inAdsGridView adsGridView: AdRecommendationsGridView) -> Int
    func numberOfColumns(inAdsGridView adsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration?
    func adsGridView(_ adsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type]
    func adsGridView(_ adsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat
    func adsGridView(_ adsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func adsGridView(_ adsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func adsGridView(_ adsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat)
}

public class AdRecommendationsGridView: UIView {
    public enum ColumnConfiguration {
        case fullWidth
        case columns(Int)
    }

    // MARK: - Internal properties

    private lazy var collectionViewLayout: AdsGridViewLayout = {
        let layout = AdsGridViewLayout()
        layout.delegate = self
        return layout
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

    private weak var delegate: AdRecommendationsGridViewDelegate?
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

    public init(delegate: AdRecommendationsGridViewDelegate, dataSource: AdsGridViewDataSource) {
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
        if let cell = collectionView.cellForItem(at: indexPath) as? AdRecommendationCell {
            cell.isFavorite = isFavorite
        }
    }

    public func scrollToTop(animated: Bool = true) {
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension AdRecommendationsGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.adsGridView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.adsGridView(self, didScrollInScrollView: scrollView)
    }
}

// MARK: - UICollectionViewDataSource

extension AdRecommendationsGridView: UICollectionViewDataSource {
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
        if let cell = cell as? ImageLoadable {
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

extension AdRecommendationsGridView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return imageCache.image(forKey: imagePath)
    }

    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.adsGridView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: { [weak self] image in
            if let image = image {
                self?.imageCache.add(image, forKey: imagePath)
            }

            completion(image)
        })
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
        dataSource?.adsGridView(self, cancelLoadingImageWithPath: imagePath, imageWidth: imageWidth)
    }
}

// MARK: - AdRecommendationsCellDelegate

extension AdRecommendationsGridView: AdRecommendationCellDelegate {
    public func adRecommendationCell(_ cell: AdRecommendationCell, didTapFavoriteButton button: UIButton) {
        guard let index = cell.index else { return }
        delegate?.adsGridView(self, didSelectFavoriteButton: button, on: cell, at: index)
    }
}

// MARK: - AdsGridViewLayoutDelegate

extension AdRecommendationsGridView: AdsGridViewLayoutDelegate {
    func adsGridViewLayoutNumberOfColumns(_ adsGridViewLayout: AdsGridViewLayout) -> Int {
        switch dataSource?.numberOfColumns(inAdsGridView: self) {
        case .fullWidth: return 1
        case .columns(let columns) where columns > 1 && columns <= 3:
            return columns
        default:
            return traitCollection.horizontalSizeClass == .regular ? 3 : 2
        }
    }

    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, heightForHeaderViewInCollectionView collectionView: UICollectionView) -> CGFloat? {
        return headerView?.frame.size.height
    }

    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        return dataSource?.adsGridView(self, heightForItemWithWidth: width, at: indexPath) ?? 0
    }
}

// MARK: - RefreshControlDelegate

extension AdRecommendationsGridView: RefreshControlDelegate {
    public func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl) {
        delegate?.adsGridViewDidStartRefreshing(self)
    }
}
