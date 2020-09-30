//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class RibbonDemoView: UIView {
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

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
        let arrangedStackViews = ribbonViews.map { ribbonView -> UIStackView in
            ribbonView.translatesAutoresizingMaskIntoConstraints = false
            ribbonView.setContentHuggingPriority(.required, for: .horizontal)

            let rowStackView = UIStackView(axis: .horizontal, withAutoLayout: true)
            rowStackView.addArrangedSubviews([ribbonView, UIView(withAutoLayout: true)])
            return rowStackView
        }

        stackView.addArrangedSubviews(arrangedStackViews)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS)
        ])
    }
}
