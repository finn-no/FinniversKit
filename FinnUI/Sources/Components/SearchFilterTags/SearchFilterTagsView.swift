//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SearchFilterTagsViewDelegate: AnyObject {
    func searchFilterTagsViewDidSelectFilter(_ view: SearchFilterTagsView)
    func searchFilterTagsView(_ view: SearchFilterTagsView, didRemoveTagAt index: Int)
    func searchFilterTagsView(_ view: SearchFilterTagsView, didTapSearchFilterTagAt index: Int)
}

public protocol SearchFilterTagsViewModel {
    var removeTagIcon: UIImage { get }
    var filterIcon: UIImage { get }
    var filterButtonTitle: String { get }
}

@objc public class SearchFilterTagsView: UIView {
    public weak var delegate: SearchFilterTagsViewDelegate?
    public static let height = 2 * SearchFilterTagsView.verticalMargin + SearchFilterTagCell.height

    public var maxFilterButtonWidth: CGFloat {
        filterButtonView.contentWidth
    }

    // MARK: - Internal properties
    static let font = UIFont.captionStrong

    // MARK: - Private properties

    private static let verticalMargin = .spacingS + .spacingXXS
    private static let horizontalMargin: CGFloat = .spacingS
    private static let cellSpacing: CGFloat = .spacingXS
    private static let filterButtonTrailingMargin: CGFloat = .spacingS

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
        collectionView.contentInset = UIEdgeInsets(
            trailing: SearchFilterTagsView.horizontalMargin
        )
        return collectionView
    }()

    private lazy var filterButtonView: SearchFilterButtonView = {
        let button = SearchFilterButtonView(title: viewModel.filterButtonTitle, icon: viewModel.filterIcon)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.delegate = self
        return button
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private lazy var filterButtonWidthConstraint = filterButtonView.widthAnchor.constraint(equalToConstant: maxFilterButtonWidth)

    private let viewModel: SearchFilterTagsViewModel
    private var searchFilterTags = [SearchFilterTagCellViewModel]()

    private var minFilterButtonWidth: CGFloat {
        SearchFilterButtonView.minWidth
    }

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
            filterButtonWidthConstraint,

            collectionView.leadingAnchor.constraint(equalTo: filterButtonView.trailingAnchor, constant: SearchFilterTagsView.filterButtonTrailingMargin),
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

    public func configure(with searchFilterTags: [SearchFilterTagCellViewModel], reloadSection: Bool = true) {
        let searchFilterTagsDidChange = self.searchFilterTags != searchFilterTags
        self.searchFilterTags = searchFilterTags

        guard
            searchFilterTagsDidChange,
            reloadSection
        else { return }

        UIView.performWithoutAnimation {
            collectionView.reloadSections([0])
        }
    }

    // MARK: - Private methods

    private func title(at indexPath: IndexPath) -> String {
        searchFilterTags[indexPath.item].title
    }
}

// MARK: - UICollectionViewDataSource

extension SearchFilterTagsView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchFilterTags.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SearchFilterTagCell.self, for: indexPath)
        cell.configure(with: searchFilterTags[indexPath.item], icon: viewModel.removeTagIcon)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchFilterTagsView: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let newWidth = filterButtonWidthConstraint.constant - offset

        if newWidth > maxFilterButtonWidth {
            filterButtonWidthConstraint.constant = maxFilterButtonWidth
        } else if newWidth < minFilterButtonWidth {
            filterButtonWidthConstraint.constant = minFilterButtonWidth
        } else {
            filterButtonWidthConstraint.constant = newWidth
            scrollView.contentOffset.x = 0
        }

        let sizeRange = maxFilterButtonWidth - minFilterButtonWidth
        let visibleRatio = (filterButtonWidthConstraint.constant - minFilterButtonWidth) / sizeRange
        let newAlpha: CGFloat = visibleRatio > 0.25 ? visibleRatio : 0
        filterButtonView.updateLabel(withAlpha: newAlpha)
    }
}

// MARK: - SearchFilterButtonViewDelegate

extension SearchFilterTagsView: SearchFilterButtonViewDelegate {
    func searchFilterButtonViewDidSelectFilter(_ searchFilterButtonView: SearchFilterButtonView) {
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

    func searchFilterTagCellWasSelected(_ cell: SearchFilterTagCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        delegate?.searchFilterTagsView(self, didTapSearchFilterTagAt: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchFilterTagsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var cellWidth = SearchFilterTagCell.width(for: title(at: indexPath))
        cellWidth = min(collectionView.bounds.width, cellWidth)
        cellWidth = max(cellWidth, SearchFilterTagCell.minWidth)
        return CGSize(width: cellWidth, height: SearchFilterTagCell.height)
    }
}
