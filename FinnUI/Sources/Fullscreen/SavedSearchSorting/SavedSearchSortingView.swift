//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol SavedSearchSortingViewDelegate: AnyObject {
    func savedSearchSortingView(_ view: SavedSearchSortingView, didSelectSortOption option: SavedSearchSortOption)
}

public final class SavedSearchSortingView: UIView {
    public static let totalHeight = SortSelectionView.rowHeight * CGFloat(SavedSearchSortOption.allCases.count)

    // MARK: - Public properties

    public weak var delegate: SavedSearchSortingViewDelegate?

    // MARK: - Private properties

    private let sortingOptions: [SavedSearchSortOptionModel]
    private var selectedSortOption: SavedSearchSortOption

    private lazy var sortingView: SortSelectionView = {
        let view = SortSelectionView(sortingOptions: sortingOptions, selectedSortOptionIdentifier: selectedSortOption.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public init(viewModel: SavedSearchSortingViewModel, selectedSortOption: SavedSearchSortOption) {
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

extension SavedSearchSortingView: SortSelectionViewDelegate {
    public func sortSelectionView(_ view: SortSelectionView, didSelectSortOptionWithIdentifier selectedIdentifier: String) {
        guard let sortOption = SavedSearchSortOption(rawValue: selectedIdentifier) else { return }
        delegate?.savedSearchSortingView(self, didSelectSortOption: sortOption)
    }
}

// MARK: - Private extensions / types

private extension SavedSearchSortingViewModel {
    var toSortingOptions: [SavedSearchSortOptionModel] {
        [
            SavedSearchSortOptionModel(title: lastChangedText, savedSearchSortOption: .lastChanged),
            SavedSearchSortOptionModel(title: lastCreatedText, savedSearchSortOption: .lastCreated),
            SavedSearchSortOptionModel(title: alphabeticalText, savedSearchSortOption: .alphabetical)
        ]
    }
}

private extension SavedSearchSortOption {
    var icon: FinniversImageAsset {
        switch self {
        case .lastChanged:
            return .republish
        case .lastCreated:
            return .favoritesSortLastAdded
        case .alphabetical:
            return .alphabeticalSortingAscending
        }
    }
}

private struct SavedSearchSortOptionModel: SortSelectionOptionModel {
    let title: String
    let savedSearchSortOption: SavedSearchSortOption
    var identifier: String { savedSearchSortOption.rawValue }
    var icon: UIImage { UIImage(named: savedSearchSortOption.icon) }

    init(title: String, savedSearchSortOption: SavedSearchSortOption) {
        self.title = title
        self.savedSearchSortOption = savedSearchSortOption
    }
}
