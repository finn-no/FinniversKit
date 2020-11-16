//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import FinniversKit

public protocol ProjectUnitsViewDelegate: AnyObject {
    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, didTapFavoriteButton button: UIButton, forIndex index: Int)
    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, didSelectUnitAtIndex index: Int)
}

public protocol ProjectUnitsViewDataSource: AnyObject {
    func numberOfItems(inProjectUnitsView view: ProjectUnitsView) -> Int
    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, modelAtIndex index: Int) -> ProjectUnitViewModel?
    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, unitAtIndexIsFavorite index: Int) -> Bool
}

public class ProjectUnitsView: UIView {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .bgPrimary
        collectionView.contentInset = UIEdgeInsets(vertical: 0, horizontal: horizontalSpacing)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProjectUnitCell.self)
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = isPagingEnabled ? PagingCollectionViewLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = isPagingEnabled ? 25 : 35
        layout.itemSize = CGSize(
            width: ProjectUnitCell.width,
            height: ProjectUnitCell.height
        )
        return layout
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(withAutoLayout: true)
        pageControl.pageIndicatorTintColor = UIColor.pagingColor.withAlphaComponent(0.2)
        pageControl.currentPageIndicatorTintColor = .pagingColor
        pageControl.addTarget(self, action: #selector(handlePageControlValueChange), for: .valueChanged)
        pageControl.currentPage = 0
        pageControl.numberOfPages = 1
        return pageControl
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: titleStyle, withAutoLayout: true)
        label.text = title
        return label
    }()

    private var isPagingEnabled: Bool {
        !isHorizontalSizeClassRegular
    }

    private var horizontalSpacing: CGFloat {
        isPagingEnabled ? .spacingS : 0
    }

    private let title: String?
    private let titleStyle: Label.Style
    private static let titleBottomSpacing: CGFloat = .spacingS
    private static let bottomSpacing: CGFloat = .spacingS

    // MARK: - Public properties

    public weak var delegate: ProjectUnitsViewDelegate?
    public weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    public weak var dataSource: ProjectUnitsViewDataSource?

    // MARK: - Init

    public init(title: String?, titleStyle: Label.Style = .title3Strong) {
        self.title = title
        self.titleStyle = titleStyle
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(collectionView)
        addSubview(titleLabel)

        if isPagingEnabled {
            addSubview(pageControl)
        }

        var constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -ProjectUnitsView.titleBottomSpacing),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]

        if isPagingEnabled {
            constraints.append(contentsOf: [
                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
                pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
                pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ProjectUnitsView.bottomSpacing)
            ])
        } else {
            constraints.append(
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ProjectUnitsView.bottomSpacing)
            )
        }

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Public methods

    public func reloadData() {
        collectionView.reloadData()
    }

    public func updateFavoriteButtonStates() {
        guard
            let dataSource = dataSource,
            let visibleCells = collectionView.visibleCells as? [ProjectUnitCell]
        else { return }

        for cell in visibleCells {
            if let cellIndex = collectionView.indexPath(for: cell) {
                cell.isFavorite = dataSource.projectUnitsView(self, unitAtIndexIsFavorite: cellIndex.row)
            }
        }
    }

    public override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        let titleHeight = titleLabel.intrinsicContentSize.height + ProjectUnitsView.titleBottomSpacing
        let pageControlHeight = isPagingEnabled ? pageControl.intrinsicContentSize.height : 0

        let totalHeight = titleHeight + ProjectUnitCell.height + pageControlHeight + ProjectUnitsView.bottomSpacing

        return CGSize(
            width: targetSize.width,
            height: totalHeight
        )
    }

    // MARK: - Private methods

    @objc private func handlePageControlValueChange() {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func configurePageControl(withNumberOfPages numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
    }
}

// MARK: - UICollectionViewDataSource

extension ProjectUnitsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = dataSource?.numberOfItems(inProjectUnitsView: self) ?? 0
        configurePageControl(withNumberOfPages: numberOfItems)
        return numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProjectUnitCell.self, for: indexPath)
        guard let dataSource = dataSource else { return cell }

        cell.remoteImageViewDataSource = remoteImageViewDataSource
        cell.delegate = self

        if let viewModel = dataSource.projectUnitsView(self, modelAtIndex: indexPath.row) {
            cell.configure(with: viewModel)
        }
        cell.isFavorite = dataSource.projectUnitsView(self, unitAtIndexIsFavorite: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProjectUnitsView: UICollectionViewDelegate {
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard isPagingEnabled else { return }

        let targetOffsetX = targetContentOffset.pointee.x
        let center = CGPoint(x: targetOffsetX + scrollView.frame.midX, y: scrollView.frame.midY)

        if let indexPath = collectionView.indexPathForItem(at: center) {
            pageControl.currentPage = indexPath.row
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.projectUnitsView(self, didSelectUnitAtIndex: indexPath.row)
    }
}

// MARK: - ProjectUnitCellDelegate

extension ProjectUnitsView: ProjectUnitCellDelegate {
    func projectUnitCell(_ projectUnitCell: ProjectUnitCell, didTapFavoriteButton button: UIButton) {
        guard let indexPath = collectionView.indexPath(for: projectUnitCell) else { return }
        delegate?.projectUnitsView(self, didTapFavoriteButton: button, forIndex: indexPath.row)
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

private extension UIColor {
    static var pagingColor: UIColor {
        .dynamicColorIfAvailable(defaultColor: .stone, darkModeColor: UIColor(hex: "#828699"))
    }
}
