//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

public class MarketCollectionViewCellDemoView: UIView {

    // MARK: - Internal properties

    lazy var dataSource: [Market] = {
        return Market.allMarkets
    }()

    @objc private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        collectionView.register(MarketCollectionViewCell.self)
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Functionality

    public func calculateSize(constrainedTo width: CGFloat) -> CGSize {
        let size = itemSize(for: width)
        let line = lineSpacing(for: width)
        let inst = insets(for: width)
        let rows = numberOfRows(for: width)

        let height = (size.height * CGFloat(rows)) + (line * CGFloat(rows - 1)) + inst.top + inst.bottom

        return CGSize(width: width, height: height)
    }

    // MARK: - Private

    private func numberOfRows(for viewWidth: CGFloat) -> Int {
        let modelsCount = dataSource.count
        return Int(ceil(Double(modelsCount) / Double(MarketListViewConfigurable(width: viewWidth).itemsPerRow)))
    }

    private func itemSize(for viewWidth: CGFloat) -> CGSize {
        let screenWidth = MarketListViewConfigurable(width: viewWidth)
        let itemSize = CGSize(width: viewWidth / screenWidth.itemsPerRow - screenWidth.sideMargins - screenWidth.interimSpacing, height: screenWidth.itemHeight)
        return itemSize
    }

    private func insets(for viewWidth: CGFloat) -> UIEdgeInsets {
        let screenWidth = MarketListViewConfigurable(width: viewWidth)
        return screenWidth.edgeInsets
    }

    private func lineSpacing(for viewWidth: CGFloat) -> CGFloat {
        let screenWidth = MarketListViewConfigurable(width: viewWidth)
        return screenWidth.lineSpacing
    }

    private func interimSpacing(for viewWidth: CGFloat) -> CGFloat {
        let screenWidth = MarketListViewConfigurable(width: viewWidth)
        return screenWidth.interimSpacing
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MarketCollectionViewCellDemoView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize(for: bounds.width)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets(for: bounds.width)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing(for: bounds.width)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interimSpacing(for: bounds.width)
    }
}

// MARK: - UICollectionViewDataSource

extension MarketCollectionViewCellDemoView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MarketCollectionViewCell.self, for: indexPath)
        cell.model = dataSource[indexPath.row]
        return cell
    }
}
