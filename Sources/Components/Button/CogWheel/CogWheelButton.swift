//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public final class CogWheelButton: UIButton {
    private let corners: UIRectCorner
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
        imageView.tintColor = .iconTintColor
        return imageView
    }()

    // MARK: - Overrides

    public override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? .buttonHighlightedColor : .buttonBackgroundColor
            contentView.alpha = isHighlighted ? 0.8 : 1
        }
    }

    public override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .buttonHighlightedColor : .buttonBackgroundColor
            contentView.alpha = isSelected ? 0.8 : 1
        }
    }

    public override var intrinsicContentSize: CGSize {
        let size: CGFloat = 44
        return CGSize(width: size, height: size)
    }

    // MARK: - Init

    @objc public required init(corners: UIRectCorner, autoLayout: Bool) {
        self.corners = corners
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()
        let radius = CGSize(width: defaultContentSize / 2, height: defaultContentSize / 2)
        let path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: corners, cornerRadii: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        contentView.layer.mask = mask
    }

    private func setup() {
        addSubview(contentView)
        contentView.addSubview(iconImageView)

        let contentWidthMultiplier: CGFloat = defaultContentSize / intrinsicContentSize.width
        let contentHeightMultiplier: CGFloat = defaultContentSize / intrinsicContentSize.height

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: contentWidthMultiplier),
            contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: contentHeightMultiplier),

            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var iconTintColor: UIColor? {
        return UIColor(r: 54, g: 52, b: 41)
    }

    static var buttonBackgroundColor: UIColor? {
        return UIColor(white: 1, alpha: 0.7)
    }

    static var buttonHighlightedColor: UIColor? {
        return UIColor.defaultButtonHighlightedBodyColor.withAlphaComponent(0.8)
    }
}
