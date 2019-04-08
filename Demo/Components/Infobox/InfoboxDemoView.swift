//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class InfoboxDemoView: UIView {
    private lazy var smallInfoboxView = InfoboxView(style: .small(backgroundColor: .ice))
    private lazy var normalInfoboxView = InfoboxView(style: .normal(backgroundColor: .white, primaryButtonIcon: UIImage(named: .webview)))

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

        NSLayoutConstraint.activate([
            smallInfoboxView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            smallInfoboxView.centerXAnchor.constraint(equalTo: centerXAnchor),
            smallInfoboxView.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),

            normalInfoboxView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            normalInfoboxView.centerXAnchor.constraint(equalTo: centerXAnchor),
            normalInfoboxView.topAnchor.constraint(equalTo: smallInfoboxView.bottomAnchor, constant: .largeSpacing),
        ])
    }
}
