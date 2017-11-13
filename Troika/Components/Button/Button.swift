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
        self.init(style: .normal)
    }

    private func setup() {
        isAccessibilityElement = true

        titleLabel?.font = .title4
        layer.cornerRadius = cornerRadius

        setTitleColor(style.textColor, for: .normal)
        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor?.cgColor
        backgroundColor = style.bodyColor
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }

    public override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)

        if state == .normal {
            accessibilityLabel = title
        }
    }

    public override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        super.setTitleColor(style.textColor, for: state)
    }
}
