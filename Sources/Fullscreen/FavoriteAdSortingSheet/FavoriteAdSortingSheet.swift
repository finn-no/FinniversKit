//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation
import Bootstrap

public protocol FavoriteAdSortingSheetDelegate: AnyObject {
    func favoriteAdSortingSheet(_ sheet: FavoriteAdSortingSheet, didSelectSortOption option: FavoriteAdSortOption)
}

public final class FavoriteAdSortingSheet: BottomSheet {
    public weak var sortingDelegate: FavoriteAdSortingSheetDelegate?

    private let selectedSortOption: FavoriteAdSortOption
    private let viewModel: FavoriteAdSortingViewModel
    private lazy var sortingView: FavoriteAdSortingView = {
        let view = FavoriteAdSortingView(viewModel: viewModel, selectedSortOption: selectedSortOption)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public required init(viewModel: FavoriteAdSortingViewModel, selectedSortOption: FavoriteAdSortOption) {
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
        preferredContentSize.height = height.compact - BottomSheet.Height.bottomInset + notchHeight * 2
    }
}

// MARK: - FavoriteAdSortingViewDelegate

extension FavoriteAdSortingSheet: FavoriteAdSortingViewDelegate {
    public func favoriteAdSortingView(_ view: FavoriteAdSortingView, didSelectSortOption option: FavoriteAdSortOption) {
        sortingDelegate?.favoriteAdSortingSheet(self, didSelectSortOption: option)
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var `default`: BottomSheet.Height {
        let height = FavoriteAdSortingView.totalHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    static let bottomInset = UIView.windowSafeAreaInsets.bottom + .largeSpacing
}
