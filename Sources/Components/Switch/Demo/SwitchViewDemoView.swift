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

    private lazy var commercialSwitchView: SwitchView = {
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
        recommendationsSwitchView.model = SwitchDefaultData1()
        commercialSwitchView.model = SwitchDefaultData2()

        addSubview(recommendationsSwitchView)
        addSubview(commercialSwitchView)

        NSLayoutConstraint.activate([
            recommendationsSwitchView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            recommendationsSwitchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            recommendationsSwitchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            commercialSwitchView.topAnchor.constraint(equalTo: recommendationsSwitchView.bottomAnchor, constant: .mediumSpacing),
            commercialSwitchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            commercialSwitchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
