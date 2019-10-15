//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class EarthHourContentView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont(name: FontType.bold.rawValue, size: 22)
        label.textAlignment = .center
        label.textColor = .textPrimary
        return label
    }()

    private(set) lazy var bodyTextLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private(set) lazy var accessoryButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.setTitleColor(.btnPrimary, for: .normal)
        button.setTitleColor(.flatButtonHighlightedTextColor, for: .highlighted)
        button.setTitleColor(.flatButtonHighlightedTextColor, for: .selected)
        button.titleLabel?.font = UIFont(name: FontType.regular.rawValue, size: 14)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func setup() {
        backgroundColor = .milk

        addSubview(titleLabel)
        addSubview(bodyTextLabel)
        addSubview(accessoryButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing + .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            bodyTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallSpacing),
            bodyTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyTextLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),

            accessoryButton.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: .mediumSpacing),
            accessoryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
