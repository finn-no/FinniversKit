//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol NotificationsListViewDelegate: NSObjectProtocol {
    func notificationsListView(_ notificationsListView: NotificationsListView, didSelectItemAtIndex index: Int)
    func notificationsListView(_ notificationsListView: NotificationsListView, willDisplayItemAtIndex index: Int)
    func notificationsListView(_ notificationsListView: NotificationsListView, didScrollInScrollView scrollView: UIScrollView)
}

public protocol NotificationsListViewDataSource: NSObjectProtocol {
    func numberOfItems(inNotificationsListView notificationsListView: NotificationsListView) -> Int
    func notificationsListView(_ notificationsListView: NotificationsListView, modelAtIndex index: Int) -> NotificationsListViewModel
    func notificationsListView(_ notificationsListView: NotificationsListView, loadImageForModel model: NotificationsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func notificationsListView(_ notificationsListView: NotificationsListView, cancelLoadingImageForModel model: NotificationsListViewModel, imageWidth: CGFloat)
}

public class NotificationsListView: UIView {

    // MARK: - Internal properties

    private lazy var collectionViewLayout: NotificationsListViewLayout = {
        return NotificationsListViewLayout(delegate: self)
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

    private weak var delegate: NotificationsListViewDelegate?
    private weak var dataSource: NotificationsListViewDataSource?

    // MARK: - External properties

    public var headerView: UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
    }

    // MARK: - Setup

    public init(delegate: NotificationsListViewDelegate, dataSource: NotificationsListViewDataSource) {
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
        collectionView.register(NotificationsListViewCell.self, forCellWithReuseIdentifier: String(describing: NotificationsListViewCell.self))
        collectionView.register(AdsGridHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: AdsGridHeaderView.self))
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

extension NotificationsListView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.notificationsListView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.notificationsListView(self, didScrollInScrollView: scrollView)
    }
}

// MARK: - UICollectionViewDataSource

extension NotificationsListView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inNotificationsListView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NotificationsListViewCell.self, for: indexPath)

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        cell.loadingColor = color
        cell.dataSource = self

        if let model = dataSource?.notificationsListView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? NotificationsListViewCell {
            cell.loadImage()
        }

        delegate?.notificationsListView(self, willDisplayItemAtIndex: indexPath.row)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader, let headerView = headerView else {
            fatalError("Suplementary view of kind '\(kind)' not supported.")
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: AdsGridHeaderView.self), for: indexPath) as! AdsGridHeaderView
        header.contentView = headerView

        return header
    }
}

// MARK: - NotificationsListViewCellDataSource

extension NotificationsListView: NotificationsListViewCellDataSource {
    public func notificationsListViewCell(_ notificationsListViewCell: NotificationsListViewCell, loadImageForModel model: NotificationsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.notificationsListView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    public func notificationsListViewCell(_ notificationsListViewCell: NotificationsListViewCell, cancelLoadingImageForModel model: NotificationsListViewModel, imageWidth: CGFloat) {
        dataSource?.notificationsListView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}

// MARK: - NotificationsListViewLayoutDelegate

extension NotificationsListView: NotificationsListViewLayoutDelegate {
    func notificationsListViewLayout(_ notificationsListViewLayout: NotificationsListViewLayout, heightForHeaderViewInCollectionView collectionView: UICollectionView) -> CGFloat? {
        return headerView?.frame.size.height
    }

    func notificationsListViewLayout(_ notificationsListViewLayout: NotificationsListViewLayout, imageHeightRatioForItemAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        guard let model = dataSource?.notificationsListView(self, modelAtIndex: indexPath.row), model.imageSize != .zero, model.imagePath != nil else {
            let defaultImageSize = CGSize(width: 104, height: 78)
            return defaultImageSize.height / defaultImageSize.width
        }

        return model.imageSize.height / model.imageSize.width
    }

    func notificationsListViewLayout(_ notificationsListViewLayout: NotificationsListViewLayout, itemNonImageHeightForItemAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        return NotificationsListViewCell.nonImageHeight
    }
}
