//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class FloatingButtonDemoView: UIView {
    private lazy var floatingButton: FloatingButton = {
        let button = FloatingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: .easterEgg), for: .normal)
        return button
    }()

    private lazy var floatingButtonWithBadge: FloatingButton = {
        let button = FloatingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: .easterEgg), for: .normal)
        button.itemsCount = 42
        return button
    }()

    private lazy var floatingButtonWithRedBadge: FloatingButton = {
        let button = FloatingButton(
            style:
                    .default.overrideStyle(
                        tintColor: .textTertiary,
                        primaryBackgroundColor: .btnPrimary,
                        highlightedBackgroundColor: .btnPrimary,
                        badgeBackgroundColor: .btnCritical,
                        badgeTextColor: .textTertiary,
                        badgeSize: 20,
                        shadowColor: UIColor(hex: "#303133").withAlphaComponent(0.9),
                        shadowOffset: CGSize(width: 0, height: 4),
                        shadowRadius: 8
                    )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: .filter).withRenderingMode(.alwaysTemplate), for: .normal)
        button.itemsCount = 11
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        configure(forTweakAt: 0)

        let stackView = UIStackView(axis: .vertical, spacing: 20, withAutoLayout: true)
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.centerInSuperview()
        stackView.addArrangedSubviews([floatingButton, floatingButtonWithBadge, floatingButtonWithRedBadge])

        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: .spacingXXL),
            floatingButton.heightAnchor.constraint(equalTo: floatingButton.widthAnchor),

            floatingButtonWithBadge.widthAnchor.constraint(equalToConstant: 44),
            floatingButtonWithBadge.heightAnchor.constraint(equalTo: floatingButtonWithBadge.widthAnchor),

            floatingButtonWithRedBadge.widthAnchor.constraint(equalToConstant: 44),
            floatingButtonWithRedBadge.heightAnchor.constraint(equalTo: floatingButtonWithRedBadge.widthAnchor),
        ])
    }
}

extension FloatingButtonDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case hideBadge
        case showBadge
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .hideBadge:
            floatingButton.itemsCount = 0
        case .showBadge:
            floatingButton.itemsCount = 10
        }
    }
}
