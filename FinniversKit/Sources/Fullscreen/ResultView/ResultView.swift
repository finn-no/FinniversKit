//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public protocol ResultViewDelegate: AnyObject {
    func resultViewDidTapActionButton(_ resultView: ResultView)
}

public class ResultView: UIView {
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
        stackView.alignment = .center
        return stackView
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: .callToAction, size: .small)
        button.addTarget(self, action: #selector(handleTapOnActionButton), for: .touchUpInside)
        return button
    }()

    private lazy var iconHeightConstraint: NSLayoutConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 40)

    // MARK: Public variables
    public weak var delegate: ResultViewDelegate?

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
        descriptionColor: UIColor = .textPrimary,
        actionButtonTitle: String? = nil,
        actionButtonStyle: Button.Style? = nil,
        icon: UIImage? = nil,
        backgroundColor: UIColor = .backgroundSubtle,
        iconTintColor: UIColor? = .iconSecondary,
        iconBottomSpacing: CGFloat = .spacingM,
        titleBottomSpacing: CGFloat = 0,
        iconHeight: CGFloat = 40
    ) {
        titleLabel.text = title
        titleLabel.textColor = titleColor
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil
        descriptionLabel.textColor = descriptionColor
        iconImageView.image = icon
        iconImageView.isHidden = icon == nil

        actionButton.isHidden = actionButtonTitle == nil
        if let actionButtonTitle = actionButtonTitle {
            if let style = actionButtonStyle {
                actionButton.size = .normal
                actionButton.style = style
            }
            actionButton.setTitle(actionButtonTitle, for: .normal)
        }

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
        stackView.addArrangedSubview(actionButton)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconHeightConstraint,
        ])

        stackView.setCustomSpacing(.spacingM, after: descriptionLabel)
        stackView.centerAndConstraintInSuperview()
    }

    // MARK: - Actions

    @objc private func handleTapOnActionButton() {
        delegate?.resultViewDidTapActionButton(self)
    }
}
