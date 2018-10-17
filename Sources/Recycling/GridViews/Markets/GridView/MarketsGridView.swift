//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol MarketsGridViewDelegate: NSObjectProtocol {
    func marketsGridView(_ marketsGridView: MarketsGridView, didSelectItemAtIndex index: Int)
}

public protocol MarketsGridViewDataSource: NSObjectProtocol {
    func numberOfItems(inMarketsGridView marketsGridView: MarketsGridView) -> Int
    func marketsGridView(_ marketsGridView: MarketsGridView, modelAtIndex index: Int) -> MarketsGridViewModel
}

public class MarketsGridView: UIView {
    // MARK: - Internal properties

    @objc private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private weak var delegate: MarketsGridViewDelegate?
    private weak var dataSource: MarketsGridViewDataSource?

    // MARK: - Setup

    public init(frame: CGRect = .zero, delegate: MarketsGridViewDelegate, dataSource: MarketsGridViewDataSource) {
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

    private func setup() {
        collectionView.register(MarketsGridViewCell.self)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Functionality

    public func reloadData() {
        collectionView.reloadData()
    }

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
        guard let modelsCount = dataSource?.numberOfItems(inMarketsGridView: self) else {
            return 0
        }

        return Int(ceil(Double(modelsCount) / Double(MarketsGridViewLayoutConfiguration(width: viewWidth).itemsPerRow)))
    }

    private func itemSize(for viewWidth: CGFloat) -> CGSize {
        let screenWidth = MarketsGridViewLayoutConfiguration(width: viewWidth)
        let itemSize = CGSize(width: viewWidth / screenWidth.itemsPerRow - screenWidth.sideMargins - screenWidth.interimSpacing, height: screenWidth.itemHeight)
        return itemSize
    }

    private func insets(for viewWidth: CGFloat) -> UIEdgeInsets {
        let screenWidth = MarketsGridViewLayoutConfiguration(width: viewWidth)
        return screenWidth.edgeInsets
    }

    private func lineSpacing(for viewWidth: CGFloat) -> CGFloat {
        let screenWidth = MarketsGridViewLayoutConfiguration(width: viewWidth)
        return screenWidth.lineSpacing
    }

    private func interimSpacing(for viewWidth: CGFloat) -> CGFloat {
        let screenWidth = MarketsGridViewLayoutConfiguration(width: viewWidth)
        return screenWidth.interimSpacing
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MarketsGridView: UICollectionViewDelegateFlowLayout {
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

extension MarketsGridView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inMarketsGridView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MarketsGridViewCell.self, for: indexPath)

        if let model = dataSource?.marketsGridView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MarketsGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.marketsGridView(self, didSelectItemAtIndex: indexPath.row)
    }
}
