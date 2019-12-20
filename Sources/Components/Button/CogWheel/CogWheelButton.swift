//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public final class CogWheelButton: UIButton {

    public enum Alignment {
        case left
        case right

        var roundingCorners: UIRectCorner {
            switch self {
            case .left:
                return .bottomRight
            case .right:
                return .bottomLeft
            }
        }
    }

    private let alignment: Alignment
    private let defaultContentSize: CGFloat = .largeSpacing - .mediumSpacing

    private var cornerConstraint: NSLayoutConstraint {
        switch alignment {
        case .left:
            return contentView.leadingAnchor.constraint(equalTo: leadingAnchor)
        case .right:
            return contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        }
    }

    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.isUserInteractionEnabled = false
        view.backgroundColor = .buttonBackgroundColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = .mediumSpacing
        view.layer.shadowOpacity = 0.6
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.isUserInteractionEnabled = false
        imageView.image = UIImage(named: .settings).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .stone
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

    public required init(alignment: Alignment, autoLayout: Bool) {
        self.alignment = alignment
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
        let path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: alignment.roundingCorners, cornerRadii: radius)
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
            cornerConstraint,
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: contentWidthMultiplier),
            contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: contentHeightMultiplier),

            iconImageView.heightAnchor.constraint(equalToConstant: 14),
            iconImageView.widthAnchor.constraint(equalToConstant: 14),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}

// MARK: - Private extensions

private extension UIColor {

    static var buttonBackgroundColor: UIColor? {
        return UIColor(white: 1, alpha: 0.7)
    }

    static var buttonHighlightedColor: UIColor? {
        return UIColor.defaultButtonHighlightedBodyColor.withAlphaComponent(0.8)
    }
}
