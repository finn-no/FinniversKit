//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

open class Button: UIButton {
    // MARK: - Internal properties

    private let cornerRadius: CGFloat = 8.0
    private var titleSize: CGSize?

    // MARK: - External properties

    public var style: Style {
        didSet { setup() }
    }

    public var size: Size {
        didSet { setup() }
    }

    // MARK: - Initializers

    public init(style: Style, size: Size = .normal, withAutoLayout: Bool = false) {
        self.style = style
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .default)
    }

    // MARK: - Overrides

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = style.backgroundColor(forState: state)
            layer.borderColor = style.borderColor(forState: state)
            calculateSizes()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            backgroundColor = style.backgroundColor(forState: state)
            layer.borderColor = style.borderColor(forState: state)
            calculateSizes()
        }
    }

    public override var isSelected: Bool {
        didSet {
            calculateSizes()
        }
    }

    public override var intrinsicContentSize: CGSize {
        guard let titleSize else {
            return CGSize.zero
        }
        let paddings = style.paddings(forSize: size)
        let imageSize = imageView?.image?.size ?? .zero

        return CGSize(
            width: titleSize.width + imageSize.width + style.margins.left + style.margins.right,
            height: titleSize.height + style.margins.top + style.margins.bottom + paddings.top + paddings.bottom
        )
    }

    public override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title else { return }

        if style == .link {
            setAsLink(title: title)
        } else {
            super.setTitle(title, for: state)
        }

        if state == .normal {
            accessibilityLabel = title
        }

        calculateSizes()
    }

    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        assertionFailure("The title color cannot be changed outside the class")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        // Border color is set in a lifecycle method to ensure it is dark mode compatible.
        // Changing border color for a `Button` must be done with the `overrideStyle` method.
        layer.borderColor = style.borderColor(forState: state)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            calculateSizes()
        }
    }

    // MARK: - Private methods

    private func setup() {
        isAccessibilityElement = true

        titleEdgeInsets = style.paddings(forSize: size)
        contentEdgeInsets = style.margins
        titleLabel?.font = style.font(forSize: size)
        titleLabel?.adjustsFontForContentSizeCategory = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor?.cgColor
        backgroundColor = style.bodyColor

        // Calling super because the method is effectively disabled for this class
        super.setTitleColor(style.textColor, for: .normal)
        super.setTitleColor(style.highlightedTextColor, for: .highlighted)
        super.setTitleColor(style.disabledTextColor, for: .disabled)
    }

    private func calculateSizes() {
        guard let title = title(for: state) else { return }

        titleSize = title.size(withConstrainedRect: bounds.size, font: style.font(forSize: size))

        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }

    private func setAsLink(title: String) {
        let textRange = NSRange(location: 0, length: title.count)
        let attributedTitle = NSMutableAttributedString(string: title)

        attributedTitle.addAttribute(.foregroundColor, value: style.textColor, range: textRange)
        let underlinedAttributedTitle = NSMutableAttributedString(string: title)

        let disabledAttributedTitle = NSMutableAttributedString(string: title)
        disabledAttributedTitle.addAttribute(
            .foregroundColor,
            value: style.disabledTextColor ?? .textInverted,
            range: textRange
        )

        let underlineAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: style.highlightedTextColor ?? style.textColor
        ]
        underlinedAttributedTitle.addAttributes(underlineAttributes, range: textRange)

        super.setAttributedTitle(attributedTitle, for: .normal)
        super.setAttributedTitle(underlinedAttributedTitle, for: .highlighted)
        super.setAttributedTitle(disabledAttributedTitle, for: .disabled)
    }
}
