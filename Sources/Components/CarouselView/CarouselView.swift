//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public typealias CarouselViewCell = UICollectionViewCell

public protocol CarouselViewDataSource: AnyObject {
    func numberOfItems(in carouselView: CarouselView) -> Int
    func carouselView(_ carouselView: CarouselView, cellForItemAt indexPath: IndexPath) -> CarouselViewCell
}

public protocol CarouselViewDelegate: AnyObject {
    func carouselView(_ carouselView: CarouselView, didSelectItemAt indexPath: IndexPath)
    func carouselViewDidEndDecelerating(_ carouselView: CarouselView)
}

public class CarouselView: UIView {

    // MARK: - Private Properties

    private weak var dataSource: CarouselViewDataSource?
    private weak var delegate: CarouselViewDelegate?

    private var shouldSetInitialLayout = true

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Init

    public init(dataSource: CarouselViewDataSource, delegate: CarouselViewDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard shouldSetInitialLayout else { return }
        shouldSetInitialLayout = false

        // Scroll to first item
        collectionView.contentOffset = CGPoint(
            x: bounds.width,
            y: collectionView.contentOffset.y
        )
    }
}

public extension CarouselView {
    var numberOfItems: Int {
        let count = collectionView.numberOfItems(inSection: 0)

        if count > 1 {
            return count - 2
        } else {
            return count
        }
    }

    var contentOffset: CGPoint {
        return CGPoint(
            x: collectionView.contentOffset.x - collectionView.bounds.width,
            y: collectionView.contentOffset.y
        )
    }

    func invalidateLayout() {
        layout.invalidateLayout()
    }

    func cellForItem(at indexPath: IndexPath) -> CarouselViewCell? {
        let translated = IndexPath(item: indexPath.item + 1, section: indexPath.section)
        return collectionView.cellForItem(at: translated)
    }

    func register(_ cellClass: CarouselViewCell.Type) {
        collectionView.register(cellClass)
    }

    func dequeue<T>(_ cellType: T.Type, for indexPath: IndexPath) -> T where T: CarouselViewCell {
        return collectionView.dequeue(cellType, for: indexPath)
    }

    func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item + 1 < collectionView.numberOfItems(inSection: 0) else {
            return
        }

        collectionView.scrollToItem(at: IndexPath(item: indexPath.item + 1, section: 0), at: scrollPosition, animated: animated)
    }
}

extension CarouselView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfItems = dataSource?.numberOfItems(in: self) else {
            return 0
        }

        if numberOfItems > 1 {
            return numberOfItems + 2
        } else {
            return numberOfItems
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = dataSource else {
            preconditionFailure("Data source is not available")
        }

        return dataSource.carouselView(self, cellForItemAt: translate(indexPath))
    }
}

extension CarouselView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView(self, didSelectItemAt: translate(indexPath))
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.carouselViewDidEndDecelerating(self)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView.isPagingEnabled else {
            return
        }

        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let targetPage = Int(targetContentOffset.pointee.x / scrollView.bounds.width)
        let deltaOffset = CGFloat(numberOfItems - 2) * scrollView.bounds.width

        if targetPage == 0 {
            targetContentOffset.pointee = CGPoint(
                x: deltaOffset,
                y: targetContentOffset.pointee.y
            )

            scrollView.contentOffset = CGPoint(
                x: scrollView.contentOffset.x + deltaOffset,
                y: scrollView.contentOffset.y
            )

        } else if targetPage == numberOfItems - 1 {
            targetContentOffset.pointee = CGPoint(
                x: scrollView.bounds.width,
                y: targetContentOffset.pointee.y
            )

            scrollView.contentOffset = CGPoint(
                x: scrollView.contentOffset.x - deltaOffset,
                y: scrollView.contentOffset.y
            )
        }
    }
}

// MARK: - Private Functions

private extension CarouselView {
    func translate(_ indexPath: IndexPath) -> IndexPath {
        let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)

        guard numberOfItems > 1 else {
            return indexPath
        }

        let translated: Int

        switch indexPath.item {
        case 0: translated = numberOfItems - 3
        case numberOfItems - 1: translated = 0
        default: translated = indexPath.item - 1
        }

        return IndexPath(
            item: translated,
            section: indexPath.section
        )
    }

    func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
}
