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
        imageView.tintColor = .iconSecondary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

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
        icon: UIImage? = nil
    ) {
        titleLabel.text = title
        titleLabel.textColor = titleColor
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil
        iconImageView.image = icon
        iconImageView.isHidden = icon == nil
    }

    // MARK: - Private methods

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

        stackView.centerAndConstraintInSuperview()
    }
}
