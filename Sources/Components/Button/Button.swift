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

    // MARK: - Setup

    public init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .default)
    }

    private func setup() {
        isAccessibilityElement = true

        titleEdgeInsets = style.paddings
        contentEdgeInsets = style.margins
        titleLabel?.font = style.font
        layer.cornerRadius = cornerRadius
        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor?.cgColor
        backgroundColor = style.bodyColor

        // Calling super because the method is effectively disabled for this class
        super.setTitleColor(style.textColor, for: .normal)
        super.setTitleColor(style.highlightedTextColor, for: .highlighted)
        super.setTitleColor(style.disabledTextColor, for: .disabled)
    }

    // MARK: - Superclass Overrides

    public override func setTitle(_ title: String?, for state: UIControlState) {
        guard let title = title else {
            return
        }

        titleHeight = title.height(withConstrainedWidth: bounds.width, font: style.font)
        titleWidth = title.width(withConstrainedHeight: bounds.height, font: style.font)

        if style == .link {
            setAsLink(title: title)
        } else {
            super.setTitle(title, for: state)
        }

        if state == .normal {
            accessibilityLabel = title
        }
    }

    public override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        assertionFailure("The title color cannot be changed outside the class")
    }

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? style.highlightedBodyColor : style.bodyColor
            layer.borderColor = isHighlighted ? style.highlightedBorderColor?.cgColor : style.borderColor?.cgColor
        }
    }

    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? style.bodyColor : style.disabledBodyColor
            layer.borderColor = isEnabled ? style.borderColor?.cgColor : style.disabledBorderColor?.cgColor
        }
    }

    public override var intrinsicContentSize: CGSize {
        guard let titleWidth = titleWidth, let titleHeight = titleHeight else {
            return CGSize.zero
        }
        let buttonSize = CGSize(width: titleWidth + style.margins.left + style.margins.right, height: titleHeight + style.margins.top + style.margins.bottom + style.paddings.top + style.paddings.bottom)

        return buttonSize
    }

    // MARK: - Private methods

    private func setAsLink(title: String) {
        let textRange = NSMakeRange(0, title.count)
        let attributedTitle = NSMutableAttributedString(string: title)

        attributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: style.textColor, range: textRange)
        let underlinedAttributedTitle = NSMutableAttributedString(string: title)
        let disabledAttributedTitle = NSMutableAttributedString(string: title)
        disabledAttributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: style.disabledTextColor ?? UIColor.milk, range: textRange)
        let underlineAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.foregroundColor: style.highlightedTextColor ?? style.textColor,
        ]
        underlinedAttributedTitle.addAttributes(underlineAttributes, range: textRange)
        super.setAttributedTitle(attributedTitle, for: .normal)
        super.setAttributedTitle(underlinedAttributedTitle, for: .highlighted)
        super.setAttributedTitle(disabledAttributedTitle, for: .disabled)
    }
}
