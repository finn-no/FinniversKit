//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class CollapsibleContentDemoView: UIView {
    private lazy var collapsibleContentView: CollapsibleContentView = {
        let view = CollapsibleContentView(withAutoLayout: true)
        view.backgroundColor = .bgTertiary
        view.layoutMargins = UIEdgeInsets(all: .spacingM)
        view.configure(with: "Spesifikasjoner", contentView: contentView)
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgSecondary
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = .spacingM
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        (1...20).forEach({ index in
            let label = Label(style: .body, withAutoLayout: true)
            label.text = "Item \(index)"
            stackView.addArrangedSubview(label)
        })

        contentView.addSubview(stackView)
        stackView.fillInSuperview()

        addSubview(collapsibleContentView)

        NSLayoutConstraint.activate([
            // one of the areas of the floating button in demo view was eating the touches where the collapisble
            // view was overlaping one of the window corners, then i added some constant to avoid that.
            collapsibleContentView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 100),
            collapsibleContentView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            collapsibleContentView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
