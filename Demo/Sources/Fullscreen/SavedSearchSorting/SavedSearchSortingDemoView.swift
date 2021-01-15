//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import FinnUI

final class SavedSearchSortingDemoView: UIView {
    private(set) lazy var view: SavedSearchSortingView = {
        let view = SavedSearchSortingView(viewModel: .default, selectedSortOption: .lastChanged)
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

// MARK: - SavedSearchSortingViewDelegate

extension SavedSearchSortingDemoView: SavedSearchSortingViewDelegate {
    func savedSearchSortingView(_ view: SavedSearchSortingView, didSelectSortOption option: SavedSearchSortOption) {
        print("\(option) selected")
    }
}

// MARK: - Private extensions

private extension SavedSearchSortingViewModel {
    static let `default` = SavedSearchSortingViewModel(
        lastChangedText: "Sist oppdatert",
        lastCreatedText: "Sist opprettet",
        alphabeticalText: "Alfabetisk"
    )
}
