//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import FinnUI

final class SearchDisplayTypeSelectionDemoView: UIView {
    private lazy var view: SearchDisplayTypeSelectionView = {
        let view = SearchDisplayTypeSelectionView(
            viewModel: .default,
            selectedDisplayTypeOption: .list,
            supportedDisplayTypeOptions: [.list, .grid, .map]
        )
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

// MARK: - SearchDisplayTypeSelectionViewDelegate

extension SearchDisplayTypeSelectionDemoView: SearchDisplayTypeSelectionViewDelegate {
    func searchDisplayTypeSelectionView(_ view: SearchDisplayTypeSelectionView, didSelectOption option: SearchDisplayTypeOption) {
        print("\(option) selected")
    }
}

// MARK: - Private extensions

private extension SearchDisplayTypeSelectionViewModel {
    static let `default` = SearchDisplayTypeSelectionViewModel(
        listText: "Liste",
        listIcon: UIImage(named: .displayTypeList),
        gridText: "Rutenett",
        gridIcon: UIImage(named: .displayTypeGrid),
        mapText: "Åpne i kart",
        mapIcon: UIImage(named: .pin)
    )
}
