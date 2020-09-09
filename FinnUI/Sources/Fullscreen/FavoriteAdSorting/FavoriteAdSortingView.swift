//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol FavoriteAdSortingViewDelegate: AnyObject {
    func favoriteAdSortingView(_ view: FavoriteAdSortingView, didSelectSortOption option: FavoriteAdSortOption)
}

public final class FavoriteAdSortingView: UIView {
    public static let totalHeight = SortSelectionView.rowHeight * CGFloat(FavoriteAdSortOption.allCases.count)

    // MARK: - Public properties

    public weak var delegate: FavoriteAdSortingViewDelegate?

    // MARK: - Private properties

    private let sortingOptions: [FavoriteAdSortOptionModel]
    private var selectedSortOption: FavoriteAdSortOption

    private lazy var sortingView: SortSelectionView = {
        let view = SortSelectionView(sortingOptions: sortingOptions, selectedSortOptionIdentifier: selectedSortOption.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public init(viewModel: FavoriteAdSortingViewModel, selectedSortOption: FavoriteAdSortOption) {
        self.sortingOptions = viewModel.toSortingOptions
        self.selectedSortOption = selectedSortOption
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(sortingView)
        sortingView.fillInSuperview()
    }
}

// MARK: - SortSelectionViewDelegate

extension FavoriteAdSortingView: SortSelectionViewDelegate {
    public func sortSelectionView(_ view: SortSelectionView, didSelectSortOptionWithIdentifier selectedIdentifier: String) {
        guard let sortOption = FavoriteAdSortOption(rawValue: selectedIdentifier) else { return }
        delegate?.favoriteAdSortingView(self, didSelectSortOption: sortOption)
    }
}

// MARK: - Private extensions / types

private extension FavoriteAdSortingViewModel {
    var toSortingOptions: [FavoriteAdSortOptionModel] {
        [
            FavoriteAdSortOptionModel(title: lastAddedText, favoriteSortOption: .lastAdded),
            FavoriteAdSortOptionModel(title: statusText, favoriteSortOption: .status),
            FavoriteAdSortOptionModel(title: lastUpdatedText, favoriteSortOption: .lastUpdated),
            FavoriteAdSortOptionModel(title: distanceText, favoriteSortOption: .distance)
        ]
    }
}

private extension FavoriteAdSortOption {
    var icon: FinniversImageAsset {
        switch self {
        case .lastAdded:
            return .favoritesSortLastAdded
        case .status:
            return .favoritesSortAdStatus
        case .lastUpdated:
            return .republish
        case .distance:
            return .favoritesSortDistance
        }
    }
}

private struct FavoriteAdSortOptionModel: SortSelectionOptionModel {
    let title: String
    let favoriteSortOption: FavoriteAdSortOption
    var identifier: String { favoriteSortOption.rawValue }
    var icon: UIImage { UIImage(named: favoriteSortOption.icon) }

    init(title: String, favoriteSortOption: FavoriteAdSortOption) {
        self.title = title
        self.favoriteSortOption = favoriteSortOption
    }
}
