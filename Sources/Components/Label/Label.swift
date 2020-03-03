//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Label: UILabel {

    // MARK: - Public properties

    public var isCopyable = false

    // MARK: - Setup

    public init(style: Style, withAutoLayout: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        self.style = style
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))

        isAccessibilityElement = true

        accessibilityLabel = text
        font = style?.font
        textColor = .textPrimary
        adjustsFontForContentSizeCategory = true
    }

    // MARK: - Dependency injection

    public private(set) var style: Style?
}

// MARK: - Copying extension

extension Label {
    public override var canBecomeFirstResponder: Bool { isCopyable }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        action == #selector(copy(_:))
    }

    public override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }

    @objc private func handleLongPress(_ recognizer: UIGestureRecognizer) {
        guard recognizer.state == .began else { return }

        UIMenuController.shared.setTargetRect(bounds, in: self)
        UIMenuController.shared.setMenuVisible(true, animated:true)
        becomeFirstResponder()
    }
}
