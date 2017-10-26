//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol MarketGridCollectionViewDelegate: NSObjectProtocol {
    func didSelect(item: MarketGridPresentable, in gridView: MarketGridView)
}

public class MarketGridView: UIView {

    // Mark: - Internal properties

    @objc private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private weak var delegate: MarketGridCollectionViewDelegate?

    // Mark: - Setup

    public init(frame: CGRect = .zero, delegate: MarketGridCollectionViewDelegate) {
        super.init(frame: frame)

        self.delegate = delegate

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
        collectionView.register(MarketGridCell.self)
        addSubview(collectionView)
    }

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    // Mark: - Dependency injection

    public var marketGridPresentables: [MarketGridPresentable] = [MarketGridPresentable]() {
        didSet {
            collectionView.reloadData()
        }
    }

    // Mark: - Functionality

    public func calculateSize(constrainedTo width: CGFloat) -> CGSize {
        let size = itemSize(for: width)
        let line = lineSpacing(for: width)
        let inst = insets(for: width)
        let rows = numberOfRows(for: width)

        let height = (size.height * CGFloat(rows)) + (line * CGFloat(rows - 1)) + inst.top + inst.bottom

        return CGSize(width: width, height: height)
    }

    // Mark: - Private

    private func numberOfRows(for viewWidth: CGFloat) -> Int {
        return Int(ceil(Double(marketGridPresentables.count) / Double(ScreenSizeCategory(width: viewWidth).itemsPerRow)))
    }

    private func itemSize(for viewWidth: CGFloat) -> CGSize {
        let screenWidth = ScreenSizeCategory(width: viewWidth)
        let itemSize = CGSize(width: viewWidth / screenWidth.itemsPerRow - screenWidth.sideMargins - screenWidth.interimSpacing, height: screenWidth.itemHeight)
        return itemSize
    }

    private func insets(for viewWidth: CGFloat) -> UIEdgeInsets {
        let screenWidth = ScreenSizeCategory(width: viewWidth)
        return screenWidth.edgeInsets
    }

    private func lineSpacing(for viewWidth: CGFloat) -> CGFloat {
        let screenWidth = ScreenSizeCategory(width: viewWidth)
        return screenWidth.lineSpacing
    }

    private func interimSpacing(for viewWidth: CGFloat) -> CGFloat {
        let screenWidth = ScreenSizeCategory(width: viewWidth)
        return screenWidth.interimSpacing
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MarketGridView: UICollectionViewDelegateFlowLayout {

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

extension MarketGridView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marketGridPresentables.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MarketGridCell.self, for: indexPath)
        cell.presentable = marketGridPresentables[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MarketGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = marketGridPresentables[indexPath.row]
        delegate?.didSelect(item: item, in: self)
    }
}
