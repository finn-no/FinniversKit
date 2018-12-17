//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class CogWheelButtonDemoView: UIView {
    private lazy var cogWheelButton = CogWheelButton(corners: [.bottomRight], withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(cogWheelButton)

        NSLayoutConstraint.activate([
            cogWheelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cogWheelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
