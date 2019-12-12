//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class SearchResultListEmptyDemoView: UIView, Tweakable {

    private lazy var viewModels = [
        SearchResultListEmptyViewModel(title: "Ingen treff akkurat nå", body: "Ønsker du å bli varslet når det kommer \n nye treff i dette søket?", buttonTitle: "Ja, takk!"),
        SearchResultListEmptyViewModel(title: "Ingen treff her enda", body: "Vi sier ifra så fort det legges ut \n noe i dette søket", buttonTitle: nil)
    ]

    private lazy var searchResultListEmptyView: SearchResultListEmptyView = {
        let view = SearchResultListEmptyView()
        return view
    }()

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "With action button", description: nil) { [weak self] in
                guard let viewModel = self?.viewModels[0] else { return }
                self?.configureViewModel(viewModel)
            },
            TweakingOption(title: "Without action button", description: nil) { [weak self] in
                guard let viewModel = self?.viewModels[1] else { return }
                self?.configureViewModel(viewModel)
            }
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        addSubview(searchResultListEmptyView)
        searchResultListEmptyView.fillInSuperview()
        configureViewModel(viewModels[0])
    }

    private func configureViewModel(_ viewModel: SearchResultListEmptyViewModel) {
        searchResultListEmptyView.configure(withViewModel: viewModel, forState: .initial)
    }
}
