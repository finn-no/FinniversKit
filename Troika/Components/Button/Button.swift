//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Button: UIButton {

    // MARK: - Internal properties

    private let cornerRadius: CGFloat = 4.0
    private let buttonHeight: CGFloat = 42.0

    // MARK: - External properties

    public let style: Style

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

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }

    // MARK: - Superclass Overrides

    public override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)

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
}
