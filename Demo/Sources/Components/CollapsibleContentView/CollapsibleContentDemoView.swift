//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit

class CollapsibleContentDemoView: UIView {

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

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

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

extension CollapsibleContentDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case plainStyle
        case cardStyle
        case cardStyleWithLongTitle
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .plainStyle:
            let overriddenPlainStyle = CollapsibleContentView.Style.plain.withOverride(backgroundColor: .bgTertiary)
            configureCollapsibleContentView(style: overriddenPlainStyle, title: "Spesifikasjoner")
        case .cardStyle:
            configureCollapsibleContentView(style: .card, title: "6 tips når du skal kjøpe husdyr")
        case .cardStyleWithLongTitle:
            configureCollapsibleContentView(style: .card, title: "6 tips til deg som skal kjøpe katt, hund eller annet husdyr")
        }
    }
}
