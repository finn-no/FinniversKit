//
//  Copyright © 2023 FINN AS. All rights reserved.
//

import UIKit
import Warp

class SettingsHeaderView: UIView {

    // MARK: - Private properties

    private lazy var headerLabel: UILabel = {
        let label = Label(style: .body, numberOfLines: 0, textColor: .text, withAutoLayout: true)
        label.textAlignment = .left
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func configure(_ text: String?) {
        headerLabel.text = text
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .background
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Warp.Spacing.spacing200),
            headerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Warp.Spacing.spacing200),
            headerLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Warp.Spacing.spacing200),
            headerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Warp.Spacing.spacing200),
        ])
    }
}
