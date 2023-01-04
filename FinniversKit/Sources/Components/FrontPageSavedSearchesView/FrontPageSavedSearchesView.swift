import UIKit

public protocol FrontPageSavedSearchesViewDelegate: AnyObject {
    func frontPageSavedSearchesView(_ view: FrontPageSavedSearchesView, didSelectSavedSearch savedSearch: FrontPageSavedSearchViewModel)
    func frontPageSavedSearchesViewDidSelectActionButton(_ view: FrontPageSavedSearchesView)
}

public class FrontPageSavedSearchesView: UIView {

    // MARK: - Public properties

    public weak var delegate: FrontPageSavedSearchesViewDelegate?

    // MARK: - Internal properties

    static let topPadding: CGFloat = .spacingL
    static let height: CGFloat = headerHeight + cellHeight

    // MARK: - Private properties

    private static let headerHeight: CGFloat = 44
    private static let cellHeight: CGFloat = 100

    private typealias Datasource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

    private enum Section: Int, CaseIterable {
        case savedSearch
    }

    private var collectionViewDatasource: Datasource!
    private weak var remoteImageDataSource: RemoteImageViewDataSource?
    private var scrollToIndexPath: IndexPath?
    private let title: String
    private let buttonTitle: String

    private var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.savedSearchLayout
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(FrontPageSavedSearchCell.self)
        collectionView.register(FrontPageHeaderView.self, ofKind: FrontPageHeaderView.reuseIdentifier)
        return collectionView
    }()

    // MARK: - Init

    public init(
        title: String,
        buttonTitle: String,
        remoteImageDataSource: RemoteImageViewDataSource?,
        withAutoLayout: Bool = false
    ) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.remoteImageDataSource = remoteImageDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let indexPath = scrollToIndexPath {
            self.scrollToIndexPath = nil
            // Using centeredHorizontally for the first cell to preserve leading content inset for iOS 14 and below.
            let scrollPosition: UICollectionView.ScrollPosition = indexPath.item == 0 ? .centeredHorizontally : .left
            collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        }
    }
}

// MARK: - Public method
public extension FrontPageSavedSearchesView {
    func configure(with savedSearches: [FrontPageSavedSearchViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.savedSearch])
        snapshot.appendItems(savedSearches, toSection: .savedSearch)
        collectionViewDatasource.apply(snapshot, animatingDifferences: true)
    }

    func scrollToSavedSearch(atIndex index: Int) {
        scrollToIndexPath = IndexPath(item: index, section: Section.savedSearch.rawValue)
        setNeedsLayout()
    }
}

// MARK: - Setup
private extension FrontPageSavedSearchesView {
    func setup() {
        addSubview(collectionView)

        collectionView.backgroundColor = .bgQuaternary
        collectionView.fillInSuperview()
        collectionViewDatasource = makeDatasource()
    }
}

// MARK: - Layout
private extension FrontPageSavedSearchesView {
    private var savedSearchLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Self.cellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        //Groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(FrontPageSavedSearchCell.width), heightDimension: .absolute(Self.cellHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        //Sections
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = .spacingS + .spacingXS

        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Self.headerHeight))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: FrontPageHeaderView.reuseIdentifier, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]

        return section
    }
}

// MARK: - Datasource
private extension FrontPageSavedSearchesView {
    private func makeDatasource() -> Datasource {
        let datasource = Datasource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            let cell = collectionView.dequeue(FrontPageSavedSearchCell.self, for: indexPath)
            guard let viewModel = item as? FrontPageSavedSearchViewModel else { return cell }
            cell.configure(withModel: viewModel)
            cell.imageDatasource = self?.remoteImageDataSource
            cell.loadImage()
            return cell
        }

        datasource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }

            let headerView = collectionView.dequeue(FrontPageHeaderView.self, for: indexPath, ofKind: kind)
            headerView.configureHeaderView(
                withTitle: self.title,
                buttonTitle: self.buttonTitle,
                buttonAction: {
                    self.delegate?.frontPageSavedSearchesViewDidSelectActionButton(self)
                }
            )
            return headerView
        }

        return datasource
    }
}

// MARK: - UICollectionViewDelegate
extension FrontPageSavedSearchesView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let item = collectionViewDatasource.itemIdentifier(for: indexPath) as? FrontPageSavedSearchViewModel
        else { return }

        delegate?.frontPageSavedSearchesView(self, didSelectSavedSearch: item)
    }
}
