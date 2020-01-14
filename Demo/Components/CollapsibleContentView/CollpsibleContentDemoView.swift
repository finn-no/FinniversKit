//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class CollpsibleContentDemoView: UIView {
    private lazy var collapsibleContentView: CollapsibleContentView = {
        let view = CollapsibleContentView(withAutoLayout: true)
        view.backgroundColor = .lightGray
        view.layoutMargins = UIEdgeInsets(vertical: .mediumSpacing, horizontal: .mediumLargeSpacing)
        view.configure(with: "Spesifikasjoner", contentView: contentView)
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .red
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = .mediumLargeSpacing
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
            collapsibleContentView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            collapsibleContentView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            collapsibleContentView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
