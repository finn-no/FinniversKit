//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class ErrorView: UIView {
    // MARK: - Private variables
    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var iconHeightConstraint: NSLayoutConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 40)

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Public methods

    public func configure(
        title: String,
        titleColor: UIColor = .textPrimary,
        description: String? = nil,
        icon: UIImage? = nil,
        backgroundColor: UIColor = .bgTertiary,
        iconTintColor: UIColor? = .iconSecondary,
        iconBottomSpacing: CGFloat = .spacingM,
        titleBottomSpacing: CGFloat = 0,
        iconHeight: CGFloat = 40
    ) {
        titleLabel.text = title
        titleLabel.textColor = titleColor
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil
        iconImageView.image = icon
        iconImageView.isHidden = icon == nil

        self.backgroundColor = backgroundColor
        iconImageView.tintColor = iconTintColor

        stackView.setCustomSpacing(iconBottomSpacing, after: iconImageView)
        stackView.setCustomSpacing(titleBottomSpacing, after: titleLabel)
        iconHeightConstraint.constant = iconHeight
    }

    // MARK: - Private methods

    private func setup() {
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconHeightConstraint,
        ])

        stackView.centerAndConstraintInSuperview()
    }
}
