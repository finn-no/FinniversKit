//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteSortingDemoView: UIView {
    private(set) lazy var view: FavoriteSortingView = {
        let view = FavoriteSortingView(viewModel: .default, selectedSortOption: .lastAdded)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - FavoriteFoldersListViewDelegate

extension FavoriteSortingDemoView: FavoriteSortingViewDelegate {
    func favoriteSortingView(_ view: FavoriteSortingView, didSelectSortOption option: FavoriteSortOption) {
        print("\(option) selected")
    }
}
