//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ToggleSwitchViewDemoView: UIView {
    private lazy var toggleSwitchView: ToggleSwitchView = {
        let toggleSwitchView = ToggleSwitchView()
        toggleSwitchView.translatesAutoresizingMaskIntoConstraints = false
        return toggleSwitchView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        toggleSwitchView.model = ToggleSwitchDefaultData()

        addSubview(toggleSwitchView)
        toggleSwitchView.fillInSuperview()
    }
}
