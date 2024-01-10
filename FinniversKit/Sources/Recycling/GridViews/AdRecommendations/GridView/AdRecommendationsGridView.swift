//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdRecommendationsGridViewDelegate: AnyObject {
    func adRecommendationsGridViewDidStartRefreshing(_ adRecommendationsGridView: AdRecommendationsGridView)
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int)
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int)
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView)
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int)
}

public protocol AdRecommendationsGridViewDataSource: AnyObject {
    func numberOfItems(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> Int
    func numberOfColumns(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration?
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type]
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat)
}

public class AdRecommendationsGridView: UIView {
    public enum ColumnConfiguration {
        case fullWidth
        case columns(Int)
    }

    // MARK: - Public properties

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

    // MARK: - Internal properties

    weak var delegate: AdRecommendationsGridViewDelegate?
    weak var dataSource: AdRecommendationsGridViewDataSource?

    // MARK: - Private properties

    private let imageCache = ImageMemoryCache()

    private lazy var collectionViewLayout: AdRecommendationsGridViewLayout = {
        let layout = AdRecommendationsGridViewLayout()
        layout.delegate = self
        return layout
    }()

    // Have the collection view be private so nobody messes with it.
    public private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = RefreshControl(frame: .zero)
        refreshControl.delegate = self
        return refreshControl
    }()

    // MARK: - Init

    public init(delegate: AdRecommendationsGridViewDelegate, dataSource: AdRecommendationsGridViewDataSource) {
        super.init(frame: .zero)

        self.delegate = delegate
        self.dataSource = dataSource

        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Setup

    func setup() {
        let cellClasses = dataSource?.adRecommendationsGridView(self, cellClassesIn: collectionView) ?? []

        cellClasses.forEach { cellClass in
            collectionView.register(cellClass)
        }

        collectionView.register(AdRecommendationsGridHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Private methods

    private func setupRefreshControl() {
        collectionView.refreshControl = isRefreshEnabled ? refreshControl : nil
    }

    public func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Public methods

    public func reloadData() {
        collectionView.reloadData()
        if refreshControl.isRefreshing {
            collectionView.performBatchUpdates(nil, completion: { [weak self] _ in
                self?.endRefreshing()
                UIAccessibility.post(notification: .layoutChanged, argument: nil)
            })
        }
        UIAccessibility.post(notification: .layoutChanged, argument: nil)
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
        delegate?.adRecommendationsGridView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.adRecommendationsGridView(self, didScrollInScrollView: scrollView)
    }
}

// MARK: - UICollectionViewDataSource

extension AdRecommendationsGridView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inAdRecommendationsGridView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dataSource?.adRecommendationsGridView(self, collectionView: collectionView, cellForItemAt: indexPath) else {
            preconditionFailure("Data source not configured correctly")
        }

        if let cell = cell as? ImageLoadable {
            cell.loadImage()
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.adRecommendationsGridView(self, willDisplayItemAtIndex: indexPath.row)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let headerView = headerView else {
            fatalError("Suplementary view of kind '\(kind)' not supported.")
        }

        let header = collectionView.dequeue(AdRecommendationsGridHeaderView.self, for: indexPath, ofKind: UICollectionView.elementKindSectionHeader)
        header.contentView = headerView

        return header
    }
}

// MARK: - RemoteImageViewDataSource

extension AdRecommendationsGridView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return imageCache.image(forKey: imagePath)
    }

    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.adRecommendationsGridView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: { [weak self] image in
            if let image = image {
                self?.imageCache.add(image, forKey: imagePath)
            }

            completion(image)
        })
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
        dataSource?.adRecommendationsGridView(self, cancelLoadingImageWithPath: imagePath, imageWidth: imageWidth)
    }
}

// MARK: - AdRecommendationsCellDelegate

extension AdRecommendationsGridView: AdRecommendationCellDelegate {
    public func adRecommendationCell(_ cell: AdRecommendationCell, didTapFavoriteButton button: UIButton) {
        guard let index = cell.index else { return }
        delegate?.adRecommendationsGridView(self, didSelectFavoriteButton: button, on: cell, at: index)
    }
}

// MARK: - AdRecommendationsGridViewLayoutDelegate

extension AdRecommendationsGridView: AdRecommendationsGridViewLayoutDelegate {
    func adRecommendationsGridViewLayoutNumberOfColumns(_ layout: AdRecommendationsGridViewLayout) -> Int {
        switch dataSource?.numberOfColumns(inAdRecommendationsGridView: self) {
        case .fullWidth: return 1
        case .columns(let columns) where columns > 1 && columns <= 3:
            return columns
        default:
           var columns = traitCollection.horizontalSizeClass == .regular ? 3 : 2
           if traitCollection.preferredContentSizeCategory.isAccessibilityCategory && Config.isDynamicTypeEnabled {
              columns -= 1
           }
           return columns
        }
    }

    func adRecommendationsGridViewLayout(_ layout: AdRecommendationsGridViewLayout, heightForHeaderViewInCollectionView collectionView: UICollectionView) -> CGFloat? {
        return headerView?.frame.size.height
    }

    func adRecommendationsGridViewLayout(_ layout: AdRecommendationsGridViewLayout, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        return dataSource?.adRecommendationsGridView(self, heightForItemWithWidth: width, at: indexPath) ?? 0
    }
}

// MARK: - RefreshControlDelegate

extension AdRecommendationsGridView: RefreshControlDelegate {
    public func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl) {
        delegate?.adRecommendationsGridViewDidStartRefreshing(self)
    }
}
