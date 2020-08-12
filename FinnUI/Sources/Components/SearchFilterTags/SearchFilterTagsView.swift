//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SearchFilterTagsViewDelegate: AnyObject {
    func searchFilterTagsViewDidSelectFilter(_ view: SearchFilterTagsView)
    func searchFilterTagsView(_ view: SearchFilterTagsView, didRemoveTagAt index: Int)
}

public protocol SearchFilterTagsViewModel {
    var removeTagIcon: UIImage { get }
    var filterIcon: UIImage { get }
    var filterButtonTitle: String { get }
}

@objc public class SearchFilterTagsView: UIView {
    public weak var delegate: SearchFilterTagsViewDelegate?
    public static let height = 2 * SearchFilterTagsView.verticalMargin + SearchFilterTagCell.height

    // MARK: - Private properties

    private static let verticalMargin = .spacingS + .spacingXXS
    private static let horizontalMargin: CGFloat = .spacingS
    private static let cellSpacing: CGFloat = .spacingXS

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .spacingS
        layout.minimumInteritemSpacing = SearchFilterTagsView.cellSpacing
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(SearchFilterTagCell.self)
        collectionView.register(SearchFilterFilterCell.self)

        collectionView.contentInset = UIEdgeInsets(
            trailing: SearchFilterTagsView.horizontalMargin
        )

        return collectionView
    }()

    private lazy var filterButtonView: UIView = {
        let button = SearchFilterButtonView(withAutoLayout: true)
        button.configure(with: viewModel.filterButtonTitle, icon: viewModel.filterIcon)
        return button
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private let viewModel: SearchFilterTagsViewModel
    private var searchFilterTags = [SearchFilterTagCellViewModel]()

    // MARK: - Init

    public init(viewModel: SearchFilterTagsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(filterButtonView)
        addSubview(collectionView)
        addSubview(separatorView)

        NSLayoutConstraint.activate([
            filterButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SearchFilterTagsView.horizontalMargin),
            filterButtonView.topAnchor.constraint(equalTo: topAnchor, constant: SearchFilterTagsView.verticalMargin),
            filterButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SearchFilterTagsView.verticalMargin),

            collectionView.leadingAnchor.constraint(equalTo: filterButtonView.trailingAnchor, constant: SearchFilterTagsView.cellSpacing),
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: SearchFilterTagsView.verticalMargin),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SearchFilterTagsView.verticalMargin),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: SearchFilterTagCell.height),

            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
        ])
    }

    // MARK: - Public methods

    public func reloadData() {
        collectionView.reloadData()
    }

    public func configure(
        with searchFilterTags: [SearchFilterTagCellViewModel],
        reloadSection: Bool = true
    ) {
        let searchFilterTagsDidChange = !searchFilterTagsAreEqual(self.searchFilterTags, searchFilterTags)
        self.searchFilterTags = searchFilterTags

        guard
            searchFilterTagsDidChange,
            reloadSection
        else { return }

        UIView.performWithoutAnimation {
            collectionView.reloadSections([1])
        }
    }

    // MARK: - Private methods

    private func title(at indexPath: IndexPath) -> String {
        return searchFilterTags[indexPath.item].title
    }
}

// MARK: - UICollectionViewDataSource

extension SearchFilterTagsView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return searchFilterTags.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeue(SearchFilterFilterCell.self, for: indexPath)
            cell.configure(with: viewModel.filterButtonTitle, icon: viewModel.filterIcon)
            return cell
        }

        let cell = collectionView.dequeue(SearchFilterTagCell.self, for: indexPath)
        cell.configure(with: searchFilterTags[indexPath.item], icon: viewModel.removeTagIcon)
        cell.delegate = self

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchFilterTagsView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        delegate?.searchFilterTagsViewDidSelectFilter(self)
    }
}

// MARK: - SearchFilterTagCellDelegate

extension SearchFilterTagsView: SearchFilterTagCellDelegate {
    func searchFilterTagCellDidSelectRemove(_ cell: SearchFilterTagCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        searchFilterTags.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])

        delegate?.searchFilterTagsView(self, didRemoveTagAt: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchFilterTagsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            return CGSize(
                width: SearchFilterFilterCell.width(for: viewModel.filterButtonTitle),
                height: SearchFilterFilterCell.height
            )
        }

        var cellWidth = SearchFilterTagCell.width(for: title(at: indexPath))
        cellWidth = min(collectionView.bounds.width, cellWidth)
        cellWidth = max(cellWidth, SearchFilterTagCell.minWidth)
        return CGSize(width: cellWidth, height: SearchFilterTagCell.height)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
}

// MARK: - Private extensions

private extension SearchFilterTagsView {
    private func searchFilterTagsAreEqual(_ lhs: [SearchFilterTagCellViewModel], _ rhs: [SearchFilterTagCellViewModel]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (index, lhsTag) in lhs.enumerated() {
            let rhsTag = rhs[index]
            guard
                lhsTag.title == rhsTag.title,
                lhsTag.titleAccessibilityLabel == rhsTag.titleAccessibilityLabel,
                lhsTag.removeButtonAccessibilityLabel == rhsTag.removeButtonAccessibilityLabel,
                lhsTag.isValid == rhsTag.isValid
            else { return false }
        }
        return true
    }
}
