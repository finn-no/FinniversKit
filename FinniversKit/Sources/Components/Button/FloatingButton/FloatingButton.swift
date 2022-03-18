//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public final class FloatingButton: UIButton {
    @available(*, deprecated, message: "Use style instead.")
    public var primaryBackgroundColor: UIColor {
        get { style.primaryBackgroundColor }
        set {
            style = style.overrideStyle(primaryBackgroundColor: newValue)
        }
    }
    @available(*, deprecated, message: "Use style instead.")
    public var highlightedBackgroundColor: UIColor {
        get { style.highlightedBackgroundColor }
        set {
            style = style.overrideStyle(primaryBackgroundColor: newValue)
        }
    }
    private var style: FloatingButton.Style {
        didSet {
            configureStyle()
        }
    }
    public override var isHighlighted: Bool { didSet { updateBackgroundColor() }}
    public override var isSelected: Bool { didSet { updateBackgroundColor() }}

    public var itemsCount: Int = 0 {
        didSet {
            badgeLabel.text = "\(itemsCount)"
            badgeView.isHidden = itemsCount == 0
        }
    }

    private lazy var badgeView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = style.badgeBackgroundColor
        view.layer.cornerRadius = style.badgeSize / 2
        view.isHidden = true
        return view
    }()

    private lazy var badgeLabel: UILabel = {
        let label = Label(style: .captionStrong)
        label.textColor = style.badgeTextColor
        label.text = "12"
        label.textAlignment = .center
        return label
    }()

    private var badgeWidthConstraint: NSLayoutConstraint?

    // MARK: - Init

    public convenience init(withAutoLayout autoLayout: Bool, style: FloatingButton.Style) {
        self.init(style: style)
        translatesAutoresizingMaskIntoConstraints = !autoLayout
    }

    public override convenience init(frame: CGRect) {
        self.init(frame: frame, style: .default)
    }

    public init(frame: CGRect, style: FloatingButton.Style) {
        self.style = style
        super.init(frame: frame)
        setup()
    }

    public convenience init(style: FloatingButton.Style) {
        self.init(frame: .zero, style: style)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()

        if transform == .identity {
            layer.cornerRadius = frame.height / 2
        }
        updateLayerColors()

        if let imageView = imageView, let titleLabel = titleLabel {
            let imageSize = imageView.frame.size
            titleEdgeInsets = UIEdgeInsets(top: 0, leading: -imageSize.width, bottom: 0, trailing: 0)

            let titleSize = titleLabel.bounds.size
            imageEdgeInsets = UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -titleSize.width)
        }
    }

    private func setup() {
        configureStyle()
        contentMode = .center

        titleLabel?.font = .detail

        adjustsImageWhenHighlighted = false

        addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        badgeLabel.fillInSuperview()

        let badgeWidthConstraint = badgeView.widthAnchor.constraint(equalToConstant: style.badgeSize)
        self.badgeWidthConstraint = badgeWidthConstraint
        NSLayoutConstraint.activate([
            badgeWidthConstraint,
            badgeView.heightAnchor.constraint(equalTo: badgeView.widthAnchor),
            badgeView.topAnchor.constraint(equalTo: topAnchor, constant: -.spacingXS),
            badgeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .spacingXS),
        ])
    }

    private func updateBackgroundColor() {
        backgroundColor = isSelected || isHighlighted ? style.highlightedBackgroundColor : style.primaryBackgroundColor
    }

    private func updateLayerColors() {
        layer.shadowColor = style.shadowColor.cgColor
        layer.borderColor = style.borderColor?.cgColor
    }

    private func configureStyle() {
        updateBackgroundColor()
        updateLayerColors()
        layer.shadowOpacity = 1
        layer.borderWidth = style.borderWidth
        badgeView.backgroundColor = style.badgeBackgroundColor
        badgeView.layer.cornerRadius = style.badgeSize / 2
        badgeLabel.textColor = style.badgeTextColor
        tintColor = style.tintColor
        layer.shadowOffset = style.shadowOffset
        layer.shadowRadius = style.shadowRadius
        setTitleColor(style.titleColor, for: .normal)
        badgeWidthConstraint?.constant = style.badgeSize
    }
}
