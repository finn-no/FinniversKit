import Foundation
import UIKit
import Warp

public final class BadgeView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: Warp.Spacing.spacing50, withAutoLayout: true)
        stackView.alignment = .center
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textLabel = Label(style: .detail, withAutoLayout: true)

    // MARK: - Init

    public init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Warp.Spacing.spacing50
        layer.maskedCorners = [.layerMaxXMaxYCorner]

        addSubview(stackView)
        stackView.addArrangedSubviews([iconImageView, textLabel])

        let iconSize: CGFloat = Warp.Spacing.spacing200

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize)
        ])

        textLabel.isAccessibilityElement = true
    }

    // MARK: - Public methods

    public func configure(with viewModel: BadgeViewModel) {
        backgroundColor = viewModel.style.backgroundColor
        textLabel.textColor = viewModel.style.textColor
        textLabel.text = viewModel.title
        iconImageView.image = viewModel.icon?.withRenderingMode(.alwaysTemplate)
        iconImageView.isHidden = viewModel.icon == nil

         /// Only applies tintColor if icon is rendered as template
        iconImageView.tintColor = .icon
    }

    public func attachToTopLeadingAnchor(in superview: UIView) {
        superview.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        ])
    }
}
