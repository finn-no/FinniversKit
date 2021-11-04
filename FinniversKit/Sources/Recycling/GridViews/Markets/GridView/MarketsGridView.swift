//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class MarketsGridView: UIView, MarketsView {
    // MARK: - Internal properties

    @objc private lazy var collectionView: UICollectionView = {
        let layout = MarketsGridViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private weak var delegate: MarketsViewDelegate?
    private weak var dataSource: MarketsViewDataSource?

    private let itemSize = CGSize(width: 92, height: 72)
    private let itemSpacing: CGFloat = .spacingS
    private let sideMargin: CGFloat = .spacingM
    private let rowSpacing: CGFloat = .spacingS

    // MARK: - Setup

    public init(frame: CGRect = .zero, delegate: MarketsViewDelegate, dataSource: MarketsViewDataSource) {
        super.init(frame: frame)

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

    public override func layoutSubviews() {
        super.layoutSubviews()
        //if collectionView.bounds.width < collectionView.contentSize.width {
            addGradientMask(to: self)
        //}
    }

    private func setup() {
        clipsToBounds = false
        backgroundColor = .clear
        collectionView.register(MarketsGridViewCell.self)
        addSubview(collectionView)

        collectionView.fillInSuperview()
    }

    // MARK: - Functionality

    public func reloadData() {
        collectionView.reloadData()
    }

    public func calculateSize(constrainedTo width: CGFloat) -> CGSize {
        let gridInsets = insets(for: width)
        let rows = numberOfRows(for: width)

        let height = (itemSize.height * CGFloat(rows)) + (rowSpacing * CGFloat(rows - 1)) + gridInsets.top + gridInsets.bottom

        return CGSize(width: width, height: height)
    }

    // MARK: - Private

    private func numberOfRows(for viewWidth: CGFloat) -> CGFloat {
        guard
            let numberOfItems = dataSource?.numberOfItems(inMarketsView: self),
            numberOfItems > 0
        else {
            return 1
        }
        let items = CGFloat(numberOfItems)
        let numberOfFittingItems = viewWidth / (itemSize.width + itemSpacing)
        let fitFactor = numberOfFittingItems / items
        if fitFactor > 0.75 {
            return 1
        }
        return 2
    }

    private func insets(for viewWidth: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0,
                     left: sideMargin,
                     bottom: 0,
                     right: sideMargin)
    }

    private func lineSpacing() -> CGFloat {
        return rowSpacing
    }

    private func interimSpacing(for viewWidth: CGFloat) -> CGFloat {
        return itemSpacing
    }

    private func addGradientMask(to view: UIView) {
        let transparent = UIColor.white.withAlphaComponent(0.2).cgColor
        let opaque = UIColor.white.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: -5, width: view.bounds.width, height: view.bounds.height + 10)
        gradientLayer.colors = [opaque, transparent]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.8, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.mask = gradientLayer
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MarketsGridView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //return insets(for: bounds.width)
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return insets(for: bounds.width)
        }
        let cellWidth: CGFloat = flowLayout.itemSize.width
        let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
        var cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
        var collectionWidth = collectionView.frame.size.width
        var totalWidth: CGFloat
        collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        repeat {
            totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
            cellCount -= 1
        } while totalWidth >= collectionWidth

        if totalWidth > 0 {
            let edgeInset = (collectionWidth - totalWidth) / 2
            return UIEdgeInsets.init(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: edgeInset)
        } else {
            return flowLayout.sectionInset
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interimSpacing(for: bounds.width)
    }
}

// MARK: - UICollectionViewDataSource

extension MarketsGridView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inMarketsView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MarketsGridViewCell.self, for: indexPath)

        if let model = dataSource?.marketsView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MarketsGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.marketsView(self, didSelectItemAtIndex: indexPath.row)
    }
}
