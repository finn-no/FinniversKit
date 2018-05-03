//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdsGridViewDelegate: NSObjectProtocol {
    func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int)
    func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int)
    func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView)
}

public protocol AdsGridViewDataSource: NSObjectProtocol {
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
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .milk
        return collectionView
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
        collectionView.register(AdsGridViewCell.self, forCellWithReuseIdentifier: String(describing: AdsGridViewCell.self))
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

        cell.loadingColor = color
        cell.dataSource = self

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
        guard kind == UICollectionElementKindSectionHeader, let headerView = headerView else {
            fatalError("Suplementary view of kind '\(kind)' not supported.")
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: AdsGridHeaderView.self), for: indexPath) as! AdsGridHeaderView
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
