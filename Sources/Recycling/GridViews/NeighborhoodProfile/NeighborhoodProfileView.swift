//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol NeighborhoodProfileViewDelegate: AnyObject {
    func neighborhoodProfileView(_ view: NeighborhoodProfileView, didSelectUrl: URL?)
    func neighborhoodProfileViewDidScroll(_ view: NeighborhoodProfileView, reachedEnd: Bool)
}

public final class NeighborhoodProfileView: UIView {
    private static let headerSpacingTop: CGFloat = 24
    private static let cellWidth: CGFloat = 204
    private static var minimumCellHeight: CGFloat { return cellWidth }

    // MARK: - Public properties

    public weak var delegate: NeighborhoodProfileViewDelegate?

    // MARK: - Private properties

    private var viewModel = NeighborhoodProfileViewModel(title: "", readMoreLink: nil, cards: [])

    private lazy var headerView: NeighborhoodProfileHeaderView = {
        let view = NeighborhoodProfileHeaderView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ice
        collectionView.contentInset = UIEdgeInsets(
            top: .mediumSpacing,
            left: .mediumLargeSpacing,
            bottom: .mediumSpacing,
            right: .mediumLargeSpacing
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NeighborhoodProfileInfoViewCell.self)
        collectionView.register(NeighborhoodProfileButtonViewCell.self)
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = isPagingEnabled ? PagingCollectionViewLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(
            width: NeighborhoodProfileView.cellWidth,
            height: NeighborhoodProfileView.minimumCellHeight
        )
        return layout
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(withAutoLayout: true)
        pageControl.pageIndicatorTintColor = UIColor.primaryBlue.withAlphaComponent(0.2)
        pageControl.currentPageIndicatorTintColor = .primaryBlue
        pageControl.addTarget(self, action: #selector(handlePageControlValueChange), for: .valueChanged)
        return pageControl
    }()

    private lazy var collectionViewHeightConstraint: NSLayoutConstraint = {
        return collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight)
    }()

    private var collectionViewHeight: CGFloat {
        return collectionViewHeight(forItemHeight: collectionViewLayout.itemSize.height)
    }

    private var isPagingEnabled: Bool {
        return UIDevice.isIPhone()
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public

    public func configure(with viewModel: NeighborhoodProfileViewModel) {
        self.viewModel = viewModel

        headerView.title = viewModel.title
        headerView.buttonTitle = viewModel.readMoreLink?.title ?? ""

        resetPageControl()
        resetCollectionViewLayout()
        collectionView.reloadData()
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
    public override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        var height = NeighborhoodProfileView.headerSpacingTop
        height += NeighborhoodProfileHeaderView.height(forTitle: viewModel.title, width: targetSize.width)
        height += .mediumSpacing + collectionViewHeight(forItemHeight: calculateItemSize().height)

        if isPagingEnabled {
            height += pageControl.intrinsicContentSize.height + .mediumSpacing
        } else {
            height += .mediumLargeSpacing
        }

        return CGSize(
            width: targetSize.width,
            height: height
        )
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .ice

        addSubview(headerView)
        addSubview(collectionView)

        if isPagingEnabled {
            addSubview(pageControl)
        }

        var constraints = [
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: NeighborhoodProfileView.headerSpacingTop),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: .mediumSpacing),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionViewHeightConstraint,
        ]

        if isPagingEnabled {
            constraints.append(contentsOf: [
                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
                pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
                bottomAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: .mediumSpacing)
            ])
        } else {
            constraints.append(
                bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: .mediumLargeSpacing)
            )
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func resetPageControl() {
        pageControl.numberOfPages = viewModel.cards.count
        pageControl.currentPage = 0
        pageControl.isHidden = !isPagingEnabled || viewModel.cards.isEmpty
    }

    private func resetCollectionViewLayout() {
        collectionViewLayout.itemSize = calculateItemSize()
        collectionViewHeightConstraint.constant = collectionViewHeight
    }

    private func calculateItemSize() -> CGSize {
        let cellWidth = NeighborhoodProfileView.cellWidth
        let cellHeights = viewModel.cards.map({ height(forCard: $0, width: cellWidth) })

        return CGSize(
            width: cellWidth,
            height: cellHeights.max() ?? NeighborhoodProfileView.minimumCellHeight
        )
    }

    private func collectionViewHeight(forItemHeight itemHeight: CGFloat) -> CGFloat {
        return itemHeight + collectionView.verticalContentInsets
    }

    private func height(forCard card: NeighborhoodProfileViewModel.Card, width: CGFloat) -> CGFloat {
        switch card {
        case let .info(content, rows):
            return NeighborhoodProfileInfoViewCell.height(forContent: content, rows: rows, width: width)
        case let .button(content):
            return NeighborhoodProfileButtonViewCell.height(forContent: content, width: width)
        }
    }

    // MARK: - Actions

    @objc private func handlePageControlValueChange() {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        let reachedEnd = pageControl.currentPage == viewModel.cards.count - 1

        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.neighborhoodProfileViewDidScroll(self, reachedEnd: reachedEnd)
    }
}

// MARK: - UICollectionViewDataSource

extension NeighborhoodProfileView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let reusableCell: UICollectionViewCell
        let card = viewModel.cards[indexPath.item]

        switch card {
        case let .info(content, rows):
            let cell = collectionView.dequeue(NeighborhoodProfileInfoViewCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(withContent: content, rows: rows)
            reusableCell = cell
        case let .button(content):
            let cell = collectionView.dequeue(NeighborhoodProfileButtonViewCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(withContent: content)
            reusableCell = cell
        }

        return reusableCell
    }
}

// MARK: - UICollectionViewDelegate

extension NeighborhoodProfileView: UICollectionViewDelegate {
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let targetOffsetX = targetContentOffset.pointee.x
        let center = CGPoint(x: targetOffsetX + scrollView.frame.midX, y: scrollView.frame.midY)

        if let indexPath = collectionView.indexPathForItem(at: center) {
            pageControl.currentPage = indexPath.row
        }

        let rightOffset = scrollView.horizontalRightOffset - .mediumLargeSpacing
        let reachedEnd = targetOffsetX >= rightOffset

        delegate?.neighborhoodProfileViewDidScroll(self, reachedEnd: reachedEnd)
    }
}

// MARK: - NeighborhoodProfileHeaderViewDelegate

extension NeighborhoodProfileView: NeighborhoodProfileHeaderViewDelegate {
    func neighborhoodProfileHeaderViewDidSelectButton(_ view: NeighborhoodProfileHeaderView) {
        delegate?.neighborhoodProfileView(self, didSelectUrl: viewModel.readMoreLink?.url)
    }
}

// MARK: - NeighborhoodProfileInfoViewCellDelegate

extension NeighborhoodProfileView: NeighborhoodProfileInfoViewCellDelegate {
    func neighborhoodProfileInfoViewCellDidSelectLinkButton(_ view: NeighborhoodProfileInfoViewCell) {
        delegate?.neighborhoodProfileView(self, didSelectUrl: view.linkButtonUrl)
    }
}

// MARK: - NeighborhoodProfileButtonViewCellDelegate

extension NeighborhoodProfileView: NeighborhoodProfileButtonViewCellDelegate {
    func neighborhoodProfileButtonViewCellDidSelectLinkButton(_ view: NeighborhoodProfileButtonViewCell) {
        delegate?.neighborhoodProfileView(self, didSelectUrl: view.linkButtonUrl)
    }
}

// MARK: - UICollectionViewFlowLayout

private final class PagingCollectionViewLayout: UICollectionViewFlowLayout {
    /// Returns the centered content offset to use after an animated layout update or change.
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let bounds = collectionView?.bounds, let layoutAttributes = layoutAttributesForElements(in: bounds) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        let halfWidth = bounds.size.width / 2
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        var targetContentOffset = proposedContentOffset

        for attributes in layoutAttributes where attributes.representedElementCategory == .cell {
            let currentX = attributes.center.x - proposedContentOffsetCenterX
            let targetX = targetContentOffset.x - proposedContentOffsetCenterX

            if abs(currentX) < abs(targetX) {
                targetContentOffset.x = attributes.center.x
            }
        }

        targetContentOffset.x -= halfWidth

        return targetContentOffset
    }
}

// MARK: - Private extensions

private extension UICollectionView {
    var verticalContentInsets: CGFloat {
        return contentInset.top + contentInset.bottom
    }
}

private extension UIScrollView {
    var horizontalRightOffset: CGFloat {
        return contentSize.width - bounds.width
    }
}
