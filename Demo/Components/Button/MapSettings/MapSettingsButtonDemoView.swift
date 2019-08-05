//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class MapSettingsButtonDemoView: UIView {

    private lazy var mapSettingsButton: MapSettingsButton = MapSettingsButton(withAutoLayout: true)

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
        addSubview(mapSettingsButton)

        NSLayoutConstraint.activate([
            mapSettingsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mapSettingsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
}
