//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class InfoboxDemoView: UIView {
    private lazy var smallInfoboxLabel: Label = {
        let label = Label(style: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Style: .small(backgroundColor: .bgSecondary):"
        label.textColor = .textSecondary
        return label
    }()
    private lazy var smallInfoboxView = InfoboxView(style: .small(backgroundColor: .bgSecondary))
    private lazy var normalInfoboxLabel: Label = {
        let label = Label(style: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Style: .normal(backgroundColor: .bgPrimary, primaryButtonIcon: UIImage(named: .webview):"
        label.numberOfLines = 2
        label.textColor = .textSecondary
        return label
    }()
    private lazy var normalInfoboxView = InfoboxView(style: .normal(backgroundColor: .bgPrimary, primaryButtonIcon: UIImage(named: .webview)))

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        smallInfoboxView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallInfoboxView)
        smallInfoboxView.model = InfoboxDefaultData()

        normalInfoboxView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(normalInfoboxView)
        normalInfoboxView.model = InfoboxOpenBrowserData()

        addSubview(smallInfoboxLabel)
        addSubview(normalInfoboxLabel)

        NSLayoutConstraint.activate([
            smallInfoboxLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            smallInfoboxLabel.widthAnchor.constraint(equalTo: widthAnchor),
            smallInfoboxLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),

            smallInfoboxView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            smallInfoboxView.centerXAnchor.constraint(equalTo: centerXAnchor),
            smallInfoboxView.topAnchor.constraint(equalTo: smallInfoboxLabel.bottomAnchor, constant: .smallSpacing),

            normalInfoboxLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            normalInfoboxLabel.widthAnchor.constraint(equalTo: widthAnchor),
            normalInfoboxLabel.topAnchor.constraint(equalTo: smallInfoboxView.bottomAnchor, constant: .veryLargeSpacing),

            normalInfoboxView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            normalInfoboxView.centerXAnchor.constraint(equalTo: centerXAnchor),
            normalInfoboxView.topAnchor.constraint(equalTo: normalInfoboxLabel.bottomAnchor, constant: .smallSpacing),
        ])
    }
}
