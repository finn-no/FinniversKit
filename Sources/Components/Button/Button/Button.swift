//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Button: UIButton {
    // MARK: - Internal properties

    private let cornerRadius: CGFloat = 8.0
    private var titleHeight: CGFloat?
    private var titleWidth: CGFloat?

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
        }
    }

    public override var isEnabled: Bool {
        didSet {
            backgroundColor = style.backgroundColor(forState: state)
            layer.borderColor = style.borderColor(forState: state)
        }
    }

    public override var intrinsicContentSize: CGSize {
        guard let titleWidth = titleWidth, let titleHeight = titleHeight else {
            return CGSize.zero
        }
        let paddings = style.paddings(forSize: size)
        let buttonSize = CGSize(
            width: titleWidth + style.margins.left + style.margins.right,
            height: titleHeight + style.margins.top + style.margins.bottom + paddings.top + paddings.bottom
        )

        return buttonSize
    }

    public override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else {
            return
        }

        titleHeight = title.height(withConstrainedWidth: bounds.width, font: style.font(forSize: size))
        titleWidth = title.width(withConstrainedHeight: bounds.height, font: style.font(forSize: size))

        if style == .link {
            setAsLink(title: title)
        } else {
            super.setTitle(title, for: state)
        }

        if state == .normal {
            accessibilityLabel = title
        }
    }

    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        assertionFailure("The title color cannot be changed outside the class")
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

    private func setAsLink(title: String) {
        let textRange = NSRange(location: 0, length: title.count)
        let attributedTitle = NSMutableAttributedString(string: title)

        attributedTitle.addAttribute(.foregroundColor, value: style.textColor, range: textRange)
        let underlinedAttributedTitle = NSMutableAttributedString(string: title)

        let disabledAttributedTitle = NSMutableAttributedString(string: title)
        disabledAttributedTitle.addAttribute(
            .foregroundColor,
            value: style.disabledTextColor ?? UIColor.textTertiary,
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
