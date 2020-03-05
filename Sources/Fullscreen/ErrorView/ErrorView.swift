//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class ErrorView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public func configure(title: String, description: String? = nil, icon: UIImage? = nil) {
        titleLabel.text = title
        descriptionLabel.text = description
        iconImageView.image = icon
    }

    public func configure(title: NSAttributedString, description: String? = nil, icon: UIImage? = nil) {
        titleLabel.attributedText = title
        descriptionLabel.text = description
        iconImageView.image = icon
    }

    private func show() {
        isHidden = false
    }

    private func hide() {
        isHidden = true
    }

    private lazy var titleLabel: Label = Label(style: .title3Strong, withAutoLayout: true)

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .iconSecondary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    private func setup() {
        backgroundColor = .bgTertiary

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.setCustomSpacing(.spacingM, after: iconImageView)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
        ])

        stackView.centerInSuperview()
    }
}
