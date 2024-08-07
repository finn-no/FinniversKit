//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

public class RibbonDemoView: UIView, Demoable {
    private lazy var stackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing100, withAutoLayout: true)

    private let ribbonViews: [UIView] = [
        RibbonView(style: .success, with: "Success"),
        RibbonView(style: .error, with: "Error"),
        RibbonView(style: .warning, with: "Warning"),
        RibbonView(style: .default, with: "Default"),
        RibbonView(style: .disabled, with: "Disabled"),
        RibbonView(style: .sponsored, with: "Sponsored"),
        IconRibbonView(style: .success, with: UIImage(named: .blinkRocketMini))
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        stackView.alignment = .leading
        stackView.addArrangedSubviews(ribbonViews)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100)
        ])
    }
}
