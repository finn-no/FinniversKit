//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class IconCollectionView: UIView {
    public enum Alignment {
        case horizontal
        case vertical
    }

    // MARK: - Public properties

    public override var backgroundColor: UIColor? {
        get { collectionView.backgroundColor }
        set { collectionView.backgroundColor = newValue }
    }

    // MARK: - Private properties

    private var alignment: Alignment
    private var viewModels = [IconCollectionViewModel]()

    private lazy var collectionView: UICollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(VerticalIconCollectionViewCell.self)
        collectionView.register(HorizontalIconCollectionViewCell.self)
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = IconCollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumLineSpacing = .spacingS
        layout.minimumInteritemSpacing = 0
        return layout
    }()

    private lazy var margins: UIEdgeInsets = {
        switch alignment {
        case .horizontal:
            return UIEdgeInsets(vertical: .spacingM, horizontal: .spacingXS)
        case .vertical:
            return .zero
        }
    }()

    // MARK: - Init

    public init(alignment: Alignment = .vertical) {
        self.alignment = alignment
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    public func configure(with viewModels: [IconCollectionViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }

    private func setup() {
        backgroundColor = .background
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Overrides

    // This override exists because of how we calculate view sizes in our objectPage.
    // The objectPage needs to know the size of this view before it's added to the view hierarchy, aka. before
    // the collectionView itself knows it's own contentSize, so we need to calculate the total height of the view manually.
    //
    // All we're given to answer this question is the width attribute in `targetSize`.
    //
    // This implementation may not work for any place other than the objectPage, because:
    //   - it assumes `targetSize` contains an accurate targetWidth for this view.
    //   - it ignores any potential targetHeight.
    //   - it ignores both horizontal and vertical fitting priority.
    public override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let targetWidth = targetSize.width - margins.horizontalMargins
        let cellWidths = viewModels.map { cellWidth(forWidth: targetWidth, viewModel: $0) }

        let cellSizes = zip(viewModels, cellWidths).map { (viewModel, width) -> CGSize in
            let height = cellHeight(for: viewModel, withWidth: width)
            return CGSize(width: width, height: height)
        }

        guard let firstItem = cellSizes.first else { return targetSize }
        let numberOfCellsInRow = Int(floor(targetWidth / firstItem.width))
        let cellRows = cellSizes.chunked(into: numberOfCellsInRow)
        let totalHeight = cellRows.compactMap { $0.max(by: { $0.height < $1.height }) }.reduce(0, { $0 + $1.height })

        let extraSpacing: CGFloat = .spacingS * CGFloat(cellRows.count - 1)
        return CGSize(width: targetWidth, height: totalHeight + extraSpacing + margins.verticalMargins)
    }
}

// MARK: - UICollectionViewDataSource

extension IconCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch alignment {
        case .horizontal:
            let cell = collectionView.dequeue(HorizontalIconCollectionViewCell.self, for: indexPath)
            cell.tintColor = tintColor
            cell.configure(with: viewModels[indexPath.item])
            return cell
        case .vertical:
            let cell = collectionView.dequeue(VerticalIconCollectionViewCell.self, for: indexPath)
            cell.tintColor = tintColor
            cell.configure(with: viewModels[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension IconCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        margins
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let viewModel = viewModels[indexPath.item]
        let width = cellWidth(forWidth: collectionView.frame.width - margins.horizontalMargins, viewModel: viewModel)
        let height = cellHeight(for: viewModel, withWidth: width)

        return CGSize(width: width, height: height)
    }

    private func cellWidth(forWidth width: CGFloat, viewModel: IconCollectionViewModel) -> CGFloat {
        let width = isHorizontalSizeClassRegular
            ? max(width / min(4, CGFloat(viewModels.count)), viewModel.image.size.width * 2)
            : width / 2
        return width
    }

    private func cellHeight(for viewModel: IconCollectionViewModel, withWidth width: CGFloat) -> CGFloat {
        switch alignment {
        case .horizontal:
            return HorizontalIconCollectionViewCell.height(for: viewModel, withWidth: width)
        case .vertical:
            return VerticalIconCollectionViewCell.height(for: viewModel, withWidth: width)
        }
    }
}

// MARK: - Private extensions & types

private final class CollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        contentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

private extension UIEdgeInsets {
    var horizontalMargins: CGFloat { left + right }
    var verticalMargins: CGFloat { top + bottom }
}
