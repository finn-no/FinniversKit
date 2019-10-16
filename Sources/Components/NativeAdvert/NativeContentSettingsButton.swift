//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class NativeContentSettingsButton: UIButton {

    // MARK: - Internal properties

    var text: String? {
        didSet {
            label.text = text
        }
    }

    // MARK: - Private properties

    private let cornerRadius: CGFloat

    private let corners: UIRectCorner = [ .bottomLeft, .topRight ]
    private let defaultContentSize: CGFloat = .largeSpacing

    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.isUserInteractionEnabled = false
        view.backgroundColor = .buttonBackgroundColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = .mediumLargeSpacing
        view.layer.shadowOpacity = 0.6
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(named: .settings).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    private lazy var label: Label = {
        let label = Label(style: .detailStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        return label
    }()

    // MARK: - Overrides

    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? .buttonHighlightedColor : .buttonBackgroundColor
            contentView.alpha = isHighlighted ? 0.8 : 1
        }
    }

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .buttonHighlightedColor : .buttonBackgroundColor
            contentView.alpha = isSelected ? 0.8 : 1
        }
    }

    // MARK: - Init

    required init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: corners, cornerRadii: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        contentView.layer.mask = mask
    }

    private func setup() {
        addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: .largeSpacing),

            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            label.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -.mediumSpacing),

            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7.0),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var foregroundColor: UIColor? {
        return .bgPrimary
    }

    static var buttonBackgroundColor: UIColor? {
        return UIColor(white: 0, alpha: 0.4)
    }

    static var buttonHighlightedColor: UIColor? {
        return UIColor(white: 0, alpha: 0.3)
    }
}
