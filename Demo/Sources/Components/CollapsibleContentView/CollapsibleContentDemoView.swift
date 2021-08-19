//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class CollapsibleContentDemoView: UIView, Tweakable {

    // MARK: - Private properties

    private var collapsibleContentView: CollapsibleContentView?
    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

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
        })
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(stackView)
        stackView.fillInSuperview()

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.alwaysBounceVertical = true
    }

    private func configureCollapsibleContentView(style: CollapsibleContentView.Style, title: String) {
        collapsibleContentView?.removeFromSuperview()

        let collapsibleContentView = CollapsibleContentView(style: style, withAutoLayout: true)
        collapsibleContentView.configure(with: title, contentView: contentView)

        scrollView.addSubview(collapsibleContentView)
        collapsibleContentView.fillInSuperview(margin: .spacingM)
        collapsibleContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL).isActive = true

        self.collapsibleContentView = collapsibleContentView
    }
}
