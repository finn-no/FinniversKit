//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteAdSortingDemoView: UIView {
    private(set) lazy var view: FavoriteAdSortingView = {
        let view = FavoriteAdSortingView(viewModel: .default, selectedSortOption: .lastAdded)
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

// MARK: - FavoriteAdSortingViewDelegate

extension FavoriteAdSortingDemoView: FavoriteAdSortingViewDelegate {
    func favoriteAdSortingView(_ view: FavoriteAdSortingView, didSelectSortOption option: FavoriteAdSortOption) {
        print("\(option) selected")
    }
}
