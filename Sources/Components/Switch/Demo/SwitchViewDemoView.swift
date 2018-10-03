//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SwitchViewDemoView: UIView {
    private lazy var recommendationsSwitchView: SwitchView = {
        let switchView = SwitchView()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        recommendationsSwitchView.model = SwitchDefaultData()

        addSubview(recommendationsSwitchView)

        NSLayoutConstraint.activate([
            recommendationsSwitchView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            recommendationsSwitchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            recommendationsSwitchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
