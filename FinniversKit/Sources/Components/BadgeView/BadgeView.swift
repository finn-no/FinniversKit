import Foundation
import UIKit

public class BadgeView: UIView {
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .detailStrong, withAutoLayout: true)
        label.textColor = .badgeTextColor
        return label
    }()

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

        addSubview(iconImageView)
        addSubview(textLabel)

        let iconSize: CGFloat = 16

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),

            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingXS),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXS),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingXS),
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: BadgeViewModel) {
        textLabel.text = viewModel.title
        iconImageView.image = viewModel.icon
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
