import Foundation
import FinniversKit

public protocol ProjectUnitsViewDelegate: AnyObject {
    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, didTapFavoriteForIndex index: Int)
    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, didSelectUnitAtIndex index: Int)
}

public class ProjectUnitsView: UIView {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .bgPrimary
        collectionView.contentInset = UIEdgeInsets(vertical: 0, horizontal: .spacingM)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProjectUnitCell.self)
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 25
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
        return pageControl
    }()

    private lazy var titleLabel: Label = Label(style: titleStyle, withAutoLayout: true)

    private let title: String?
    private let titleStyle: Label.Style
    private let projectUnits: [ProjectUnitViewModel]
    private static let titleVerticalSpacing: CGFloat = .spacingS
    private static let bottomSpacing: CGFloat = .spacingS

    public weak var delegate: ProjectUnitsViewDelegate?
    public weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    public init(title: String?, projectUnits: [ProjectUnitViewModel], titleStyle: Label.Style = .title3Strong) {
        self.title = title
        self.titleStyle = titleStyle
        self.projectUnits = projectUnits
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        titleLabel.text = title

        addSubview(collectionView)
        addSubview(titleLabel)
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ProjectUnitsView.titleVerticalSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -ProjectUnitsView.titleVerticalSpacing),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ProjectUnitsView.bottomSpacing)
        ])

        collectionView.reloadData()
        pageControl.numberOfPages = projectUnits.count
        pageControl.currentPage = 0
    }

    public override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        let titleSize = titleLabel.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        let pageControlSize = pageControl.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)

        let totalHeight = titleSize.height + 2 * ProjectUnitsView.titleVerticalSpacing + ProjectUnitCell.height
            + pageControlSize.height + ProjectUnitsView.bottomSpacing

        return CGSize(
            width: targetSize.width,
            height: totalHeight
        )
    }

    @objc func handlePageControlValueChange() {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ProjectUnitsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        projectUnits.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProjectUnitCell.self, for: indexPath)
        cell.remoteImageViewDataSource = remoteImageViewDataSource
        cell.delegate = self
        cell.configure(with: projectUnits[indexPath.item])
        return cell
    }
}

extension ProjectUnitsView: UICollectionViewDelegate {
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
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.projectUnitsView(self, didSelectUnitAtIndex: indexPath.row)
    }
}

extension ProjectUnitsView: ProjectUnitCellDelegate {
    func projectUnitCellDidTapFavoriteButton(_ projectUnitCell: ProjectUnitCell) {
        guard let indexPath = collectionView.indexPath(for: projectUnitCell) else { return }
        delegate?.projectUnitsView(self, didTapFavoriteForIndex: indexPath.row)
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

private extension UIColor {
    static var pagingColor: UIColor {
        .dynamicColorIfAvailable(defaultColor: .stone, darkModeColor: UIColor(hex: "#828699"))
    }
}
