//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class InfoboxDemoView: UIView {
    private lazy var infoboxView = InfoboxView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(infoboxView)
        infoboxView.model = InfoboxDefaultData()

        NSLayoutConstraint.activate([
            infoboxView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            infoboxView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoboxView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
