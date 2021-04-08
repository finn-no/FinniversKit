//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class CollapsibleContentDemoView: UIView, Tweakable {
    // MARK: - Private properties

    private lazy var contentView = UIView(withAutoLayout: true)

    private var collapsibleContentView: CollapsibleContentView?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = .spacingM
        (1...20).forEach({ index in
            let label = Label(style: .body, withAutoLayout: true)
            label.text = "Item \(index)"
            stackView.addArrangedSubview(label)
        })
        return stackView
    }()

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Plain style", action: { [weak self] in
            let overriddenPlainStyle = CollapsibleContentView.Style.plain.withOverride(backgroundColor: .bgTertiary)
            self?.configureCollapsibleContentView(style: overriddenPlainStyle, title: "Spesifikasjoner")
        }),
        TweakingOption(title: "Card style", action: { [weak self] in
            self?.configureCollapsibleContentView(style: .card, title: "6 tips når du skal kjøpe husdyr")
        }),
        TweakingOption(title: "Card style", description: "Long title", action: { [weak self] in
            self?.configureCollapsibleContentView(style: .card, title: "6 tips til deg som skal kjøpe katt, hund eller annet husdyr")
        }),
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action?()
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(stackView)
        stackView.fillInSuperview()
    }

    private func configureCollapsibleContentView(style: CollapsibleContentView.Style, title: String) {
        collapsibleContentView?.removeFromSuperview()

        let newDemoView = CollapsibleContentView(style: style, withAutoLayout: true)
        newDemoView.configure(with: title, contentView: contentView)
        addSubview(newDemoView)

        NSLayoutConstraint.activate([
            // one of the areas of the floating button in demo view was eating the touches where the collapisble
            // view was overlaping one of the window corners, then i added some constant to avoid that.
            newDemoView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 100),
            newDemoView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            newDemoView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])

        collapsibleContentView = newDemoView
    }
}
