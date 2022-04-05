//
//  Copyright © 2022 FINN.no AS. All rights reserved.
//

import FinniversKit

class SideScrollableDemoView: UIView {
    
    // MARK: - Private properties

    lazy var sideScrollableView: SideScrollableView = {
        let sideScrollableView = SideScrollableView(withAutoLayout: true)
        return sideScrollableView
    }()
    
    lazy var label: Label = {
        let label = Label(
            style: .bodyRegular,
            withAutoLayout: true
        )
        label.textAlignment = .center
        label.text = "Select an item..."
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(sideScrollableView)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            sideScrollableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sideScrollableView.topAnchor.constraint(equalTo: topAnchor),
            sideScrollableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: sideScrollableView.bottomAnchor,
                                       constant: 50),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let viewModel = SideScrollableItemModel(
            items: [
                "Alle",
                "Aktiv (3)",
                "Påbegynte (17)",
                "Avvist (2)",
                "Lorem ipsum (42)"
            ]
        )
        sideScrollableView.configure(with: viewModel)
        sideScrollableView.delegate = self
    }
}

extension SideScrollableDemoView: SideScrollableViewDelegate {

    func sidescrollableViewDidTapItem(
        _ sidescrollableView: SideScrollableView,
        item: String,
        itemIndex: Int
    ) {
        label.text = "\(item) was selected 🎉"
    }
}
