import Foundation
import FinniversKit

public class ProjectUnitsView: UIView {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .bgPrimary
        collectionView.contentInset = UIEdgeInsets(
            top: .spacingS,
            left: .spacingM,
            bottom: .spacingS,
            right: .spacingM
        )
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
            height: 270
        )
        return layout
    }()

    private lazy var titleLabel: Label = Label(style: titleStyle, withAutoLayout: true)

    private let title: String?
    private let titleStyle: Label.Style
    private let projectUnits: [ProjectUnitViewModel]

    public weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    public init(title: String?, projectUnits: [ProjectUnitViewModel], titleStyle: Label.Style = .title3Strong) {
        self.title = title
        self.titleStyle = titleStyle
        self.projectUnits = projectUnits
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(collectionView)

        guard let title = title else {
            collectionView.fillInSuperview()
            return
        }
        titleLabel.text = title
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    public func reloadData() {
        collectionView.reloadData()
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
        print("Cell \(indexPath.item)")
        return cell
    }
}

extension ProjectUnitsView: UICollectionViewDelegate {
    
}

extension ProjectUnitsView: ProjectUnitCellDelegate {
    
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
