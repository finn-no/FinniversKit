//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

class SettingsSectionHeaderView: UITableViewHeaderFooterView {

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
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
        titleLabel.fillInSuperview(insets: UIEdgeInsets(top: .spacingM, left: .spacingM, bottom: -.spacingM, right: -.spacingM))
    }
}
