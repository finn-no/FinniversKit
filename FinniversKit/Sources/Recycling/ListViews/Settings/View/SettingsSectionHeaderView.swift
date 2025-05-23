//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit
import Warp

class SettingsSectionHeaderView: UITableViewHeaderFooterView {

    private lazy var titleLabel: Label = {
        let label = Label(
            style: .bodyStrong,
            numberOfLines: 0,
            withAutoLayout: true
        )
        label.textColor = .textSubtle
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String?) {
        titleLabel.text = text
    }

    private func setup() {
        contentView.addSubview(titleLabel)
        titleLabel.fillInSuperview(insets: UIEdgeInsets(top: Warp.Spacing.spacing200, left: Warp.Spacing.spacing200, bottom: -Warp.Spacing.spacing200, right: -Warp.Spacing.spacing200))
    }
}
