import Foundation
import UIKit

public final class BadgeView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingXS, withAutoLayout: true)
        stackView.alignment = .center
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textLabel = Label(style: .detailStrong, withAutoLayout: true)

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
        backgroundColor = .banana
        layer.cornerRadius = .spacingS
        layer.maskedCorners = [.layerMaxXMaxYCorner]

        addSubview(stackView)
        stackView.addArrangedSubviews([iconImageView, textLabel])

        let iconSize: CGFloat = .spacingM

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXS),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingXS),

            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: BadgeViewModel) {
        backgroundColor = viewModel.style.color
        textLabel.textColor = viewModel.style.textColor
        textLabel.text = viewModel.title
        iconImageView.image = viewModel.icon
        iconImageView.isHidden = viewModel.icon == nil
    }

    public func attachToTopLeadingAnchor(in superview: UIView) {
        superview.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        ])
    }
}

// MARK: - Private extensions

private extension UIColor {
    class var badgeTextColor: UIColor {
        UIColor(hex: "#885407")
    }
}
