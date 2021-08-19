//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class NewMarketsGridView: UIView, MarketsView {
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

    private func setup() {
        clipsToBounds = false
        collectionView.register(NewMarketsGridViewCell.self)
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

    private func numberOfRows(for viewWidth: CGFloat) -> CGFloat {
        return NewMarketsGridViewLayoutConfiguration(width: viewWidth).itemsPerRow
    }

    private func itemSize(for viewWidth: CGFloat) -> CGSize {
        let screenWidth = NewMarketsGridViewLayoutConfiguration(width: viewWidth)
        let numberOfSpacesBetweenOnScreenItems = screenWidth.columns - 1
        let spaceBetweenItems = screenWidth.interimSpacing * numberOfSpacesBetweenOnScreenItems
        let margins = screenWidth.sideMargins * 2
        let itemSize = CGSize(width: (viewWidth - spaceBetweenItems - margins) / screenWidth.columns, height: screenWidth.itemHeight)
        return itemSize
    }

    private func insets(for viewWidth: CGFloat) -> UIEdgeInsets {
        let screenWidth = NewMarketsGridViewLayoutConfiguration(width: viewWidth)
        return screenWidth.edgeInsets
    }

    private func lineSpacing(for viewWidth: CGFloat) -> CGFloat {
        let screenWidth = NewMarketsGridViewLayoutConfiguration(width: viewWidth)
        return screenWidth.lineSpacing
    }

    private func interimSpacing(for viewWidth: CGFloat) -> CGFloat {
        let screenWidth = NewMarketsGridViewLayoutConfiguration(width: viewWidth)
        return screenWidth.interimSpacing
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewMarketsGridView: UICollectionViewDelegateFlowLayout {
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

extension NewMarketsGridView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inMarketsView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NewMarketsGridViewCell.self, for: indexPath)

        if let model = dataSource?.marketsView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension NewMarketsGridView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.marketsView(self, didSelectItemAtIndex: indexPath.row)
    }
}

