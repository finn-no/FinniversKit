//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class EarthHourContentView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont.font(ofSize: 22, weight: .bold, textStyle: .title2)
        label.textAlignment = .center
        label.textColor = .text
        return label
    }()

    private(set) lazy var bodyTextLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textColor = .text
        label.numberOfLines = 0
        return label
    }()

    private(set) lazy var accessoryButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.setTitleColor(.backgroundPrimary, for: .normal)
        button.setTitleColor(.backgroundPrimaryActive, for: .highlighted)
        button.setTitleColor(.backgroundPrimaryActive, for: .selected)
        button.titleLabel?.font = UIFont.font(ofSize: 14, weight: .regular, textStyle: .footnote)
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
        backgroundColor = .background

        addSubview(titleLabel)
        addSubview(bodyTextLabel)
        addSubview(accessoryButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM + .spacingS),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            bodyTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
            bodyTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyTextLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),

            accessoryButton.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: .spacingS),
            accessoryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
