//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteSortingSheetDelegate: AnyObject {
    func favoriteSortingSheet(_ sortingSheet: FavoriteSortingSheet, didSelectSortOption option: FavoriteSortOption)
}

public final class FavoriteSortingSheet: BottomSheet {
    public weak var sortingDelegate: FavoriteSortingSheetDelegate?
    private weak var viewController: SortingViewController?

    // MARK: - Init

    public required init(viewModel: FavoriteSortingViewModel, selectedSortOption: FavoriteSortOption) {
        let viewController = SortingViewController(viewModel: viewModel, selectedSortOption: selectedSortOption)
        super.init(rootViewController: viewController, height: .default)
        self.viewController = viewController
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.sortingView.delegate = self
    }
}

// MARK: - FavoriteActionsListViewDelegate

extension FavoriteSortingSheet: FavoriteSortingViewDelegate {
    public func favoriteSortingView(_ view: FavoriteSortingView, didSelectSortOption option: FavoriteSortOption) {
        sortingDelegate?.favoriteSortingSheet(self, didSelectSortOption: option)
    }
}

// MARK: - Private types

private final class SortingViewController: UIViewController {
    private let viewModel: FavoriteSortingViewModel
    private let selectedSortOption: FavoriteSortOption

    private(set) lazy var sortingView: FavoriteSortingView = {
        let view = FavoriteSortingView(viewModel: viewModel, selectedSortOption: selectedSortOption)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: FavoriteSortingViewModel, selectedSortOption: FavoriteSortOption) {
        self.viewModel = viewModel
        self.selectedSortOption = selectedSortOption
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sortingView)
        sortingView.fillInSuperview()
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
