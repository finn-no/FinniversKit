//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public enum CustomSavedSearchSortOption: String, CaseIterable {
    case byDay
    case bySearch
    case flat
}

public struct NotificationGroupOptionsViewModel {
    let bySearchTitle: String
    let byDayTitle: String
    let flatTitle: String
    
    public init(bySearchTitle: String, byDayTitle: String, flatTitle: String) {
        self.bySearchTitle = bySearchTitle
        self.byDayTitle = byDayTitle
        self.flatTitle = flatTitle
    }
}

public protocol NotificationGroupOptionsViewDelegate: AnyObject {
    func notificationGroupOptionsView(_ view: NotificationGroupOptionsView, didSelect option: CustomSavedSearchSortOption)
}

public class NotificationGroupOptionsView: UIView {
    let viewModel: NotificationGroupOptionsViewModel
    
    public weak var delegate: NotificationGroupOptionsViewDelegate?
    
    private let selectedSortOption: CustomSavedSearchSortOption
    
    public init(viewModel: NotificationGroupOptionsViewModel, selectedSortOption: CustomSavedSearchSortOption) {
        self.viewModel = viewModel
        self.selectedSortOption = selectedSortOption
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    private lazy var optionsView: SortingOptionsView<CustomSavedSearchSortOption> = {
        let view = SortingOptionsView<CustomSavedSearchSortOption>(
            selectedSortOption: selectedSortOption,
            cellConfiguration: { [weak self] option -> SortOptionCellViewModel in
                switch option {
                case .byDay:
                    return .init(
                        title: self?.viewModel.byDayTitle ?? "",
                        icon: UIImage(named: .favoritesSortLastAdded)
                    )
                case .bySearch:
                    return .init(
                        title: self?.viewModel.bySearchTitle ?? "",
                        icon: UIImage(named: .magnifyingGlass)
                    )
                case .flat:
                    return .init(
                        title: self?.viewModel.flatTitle ?? "",
                        icon: UIImage(named: .clock)
                    )
                }
            }
        )
        view.delegate = self
        return view
    }()

    private func setup() {
        addSubview(optionsView)
        optionsView.fillInSuperview()
    }
}

extension NotificationGroupOptionsView: SortingOptionsViewDelegate {
    public func sortingOptionsView<SortOption>(
        _ view: SortingOptionsView<SortOption>,
        didSelectSortOption option: SortOption
    ) where SortOption : CaseIterable, SortOption : Equatable {
        guard let savedOption = option as? CustomSavedSearchSortOption else { return }

        delegate?.notificationGroupOptionsView(self, didSelect: savedOption)
    }
}
