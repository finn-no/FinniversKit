//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class SaveSearchPromptViewDemoView: UIView {

    // MARK: - Private properties

    private let viewModels: [SaveSearchPromptView.State: SaveSearchPromptViewModel] = [
        .initial: SaveSearchPromptViewModel(title: "Ønsker du å bli varslet når det \n kommer nye treff i dette søket?", positiveButtonTitle: "Ja, takk!"),
        .accept: SaveSearchPromptViewModel(title: "Søket ble lagret")
    ]

    private lazy var saveSearchPromptView: SaveSearchPromptView = {
        let view = SaveSearchPromptView(withAutoLayout: true)
        view.delegate = self
        return view
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
        saveSearchPromptView.setState(.initial, withViewModel: viewModels[.initial]!)
        addSubview(saveSearchPromptView)

        NSLayoutConstraint.activate([
            saveSearchPromptView.widthAnchor.constraint(equalTo: widthAnchor),
            saveSearchPromptView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.18),
            saveSearchPromptView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension SaveSearchPromptViewDemoView: SaveSearchPromptViewDelegate {
    func saveSearchPromptView(_ saveSearchPromptView: SaveSearchPromptView, didAcceptSaveSearch: Bool) {
        if didAcceptSaveSearch {
            saveSearchPromptView.setState(.accept, withViewModel: viewModels[.accept]!)
        } else {
            saveSearchPromptView.setState(.finished)
        }
    }
}
