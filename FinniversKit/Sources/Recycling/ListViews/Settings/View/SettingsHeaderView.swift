//
//  Copyright © 2023 FINN AS. All rights reserved.
//

import UIKit

class SettingsHeaderView: UIView {

    // MARK: - Private properties

    private lazy var headerLabel: UILabel = {
        let label = Label(style: .body, numberOfLines: 0, textColor: .textPrimary, withAutoLayout: true)
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
        headerLabel.fillInSuperview(insets: UIEdgeInsets(top: .spacingM, left: .spacingM, bottom: -.spacingM, right: -.spacingM))
    }
}
