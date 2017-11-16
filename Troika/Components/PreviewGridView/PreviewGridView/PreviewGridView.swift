//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol PreviewGridViewDelegate: NSObjectProtocol {
    func didSelect(itemAtIndex index: Int, inPreviewGridView gridView: PreviewGridView)
    func willDisplay(itemAtIndex index: Int, inPreviewGridView gridView: PreviewGridView)
    func didScroll(gridScrollView: UIScrollView)
}

public protocol PreviewGridViewDataSource: NSObjectProtocol {
    func numberOfItems(inPreviewGridView previewGridView: PreviewGridView) -> Int
    func previewGridView(_ previewGridView: PreviewGridView, modelAtIndex index: Int) -> PreviewModel
    func loadImage(for model: PreviewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func cancelLoadImage(for model: PreviewModel, imageWidth: CGFloat)
}

public class PreviewGridView: UIView {

    // MARK: - Internal properties

    private lazy var collectionViewLayout: PreviewGridLayout = {
        return PreviewGridLayout(delegate: self)
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

    private weak var delegate: PreviewGridViewDelegate?
    private weak var dataSource: PreviewGridViewDataSource?

    // MARK: - External properties

    public var headerView: UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
    }

    // MARK: - Setup

    public init(delegate: PreviewGridViewDelegate, dataSource: PreviewGridViewDataSource) {
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
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: String(describing: PreviewCell.self))
        collectionView.register(PreviewGridHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: PreviewGridHeaderView.self))
        addSubview(collectionView)
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
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
extension PreviewGridView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(itemAtIndex: indexPath.row, inPreviewGridView: self)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(gridScrollView: scrollView)
    }
}

// MARK: - UICollectionViewDataSource
extension PreviewGridView: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inPreviewGridView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PreviewCell.self), for: indexPath) as! PreviewCell

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        cell.loadingColor = color
        cell.dataSource = self

        if let model = dataSource?.previewGridView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PreviewCell {
            cell.loadImage()
        }

        delegate?.willDisplay(itemAtIndex: indexPath.row, inPreviewGridView: self)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader, let headerView = headerView else {
            fatalError("Suplementary view of kind '\(kind)' not supported.")
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: PreviewGridHeaderView.self), for: indexPath) as! PreviewGridHeaderView
        header.contentView = headerView

        return header
    }
}

// MARK: - PreviewCellDataSource
extension PreviewGridView: PreviewCellDataSource {

    public func loadImage(for model: PreviewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.loadImage(for: model, imageWidth: imageWidth, completion: completion)
    }

    public func cancelLoadImage(for model: PreviewModel, imageWidth: CGFloat) {
        dataSource?.cancelLoadImage(for: model, imageWidth: imageWidth)
    }
}

// MARK: - PreviewGridLayoutDelegate
extension PreviewGridView: PreviewGridLayoutDelegate {

    func heightForHeaderView(inCollectionView collectionView: UICollectionView) -> CGFloat? {
        return headerView?.frame.size.height
    }

    func imageHeightRatio(forItemAt indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        guard let model = dataSource?.previewGridView(self, modelAtIndex: indexPath.row), model.imageSize != .zero, model.imagePath != nil else {
            let defaultImageSize = CGSize(width: 104, height: 78)
            return defaultImageSize.height / defaultImageSize.width
        }

        return model.imageSize.height / model.imageSize.width
    }

    func itemNonImageHeight(forItemAt indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        return PreviewCell.nonImageHeight
    }
}
