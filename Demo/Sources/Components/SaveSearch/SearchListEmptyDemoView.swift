//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class SearchListEmptyDemoView: UIView, Tweakable {

    private lazy var viewModels = [
        SearchListEmptyViewModel(title: "Ingen treff akkurat nå", body: "Ønsker du å bli varslet når det kommer \n nye treff i dette søket?", buttonTitle: "Ja, takk!"),
        SearchListEmptyViewModel(title: "Ingen treff her enda", body: "Vi sier ifra så fort det legges ut \n noe i dette søket", buttonTitle: nil)
    ]

    private lazy var searchListEmptyView = SearchListEmptyView()

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
        addSubview(searchListEmptyView)
        searchListEmptyView.fillInSuperview()
        configureViewModel(viewModels[0])
    }

    private func configureViewModel(_ viewModel: SearchListEmptyViewModel) {
        searchListEmptyView.configure(with: viewModel, for: .initial)
    }
}
