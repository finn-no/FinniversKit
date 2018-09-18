//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SavedSearchSettingsViewDemoView: UIView {
    private lazy var savedSearchSettingsView: SavedSearchSettingsView = {
        let savedSearchSettingsView = SavedSearchSettingsView()
        savedSearchSettingsView.translatesAutoresizingMaskIntoConstraints = false
        return savedSearchSettingsView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        savedSearchSettingsView.model = SavedSearchSettingsViewDefaultData()

        addSubview(savedSearchSettingsView)

        NSLayoutConstraint.activate([
            savedSearchSettingsView.topAnchor.constraint(equalTo: topAnchor),
            savedSearchSettingsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            savedSearchSettingsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            savedSearchSettingsView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
