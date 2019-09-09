//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteSortingSheetDelegate: AnyObject {
    func favoriteSortingSheet(_ sortingSheet: FavoriteSortingSheet, didSelectSortOption option: FavoriteSortOption)
}

public final class FavoriteSortingSheet: BottomSheet {
    public weak var sortingDelegate: FavoriteSortingSheetDelegate?

    private let selectedSortOption: FavoriteSortOption
    private let viewModel: FavoriteSortingViewModel
    private lazy var sortingView: FavoriteSortingView = {
        let view = FavoriteSortingView(viewModel: viewModel, selectedSortOption: selectedSortOption)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public required init(viewModel: FavoriteSortingViewModel, selectedSortOption: FavoriteSortOption) {
        self.selectedSortOption = selectedSortOption
        self.viewModel = viewModel
        super.init(rootViewController: UIViewController(), height: .default)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        rootViewController.view.addSubview(sortingView)
        sortingView.fillInSuperview()
    }
}

// MARK: - FavoriteActionsListViewDelegate

extension FavoriteSortingSheet: FavoriteSortingViewDelegate {
    public func favoriteSortingView(_ view: FavoriteSortingView, didSelectSortOption option: FavoriteSortOption) {
        sortingDelegate?.favoriteSortingSheet(self, didSelectSortOption: option)
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var `default`: BottomSheet.Height {
        let bottomInset = UIView.windowSafeAreaInsets.bottom + .largeSpacing
        let height = FavoriteSortingView.totalHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }
}
