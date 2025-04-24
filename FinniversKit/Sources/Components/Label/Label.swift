//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public class Label: UILabel {

    // MARK: - Public properties

    public private(set) var style: Warp.Typography?
    public private(set) var isTextCopyable = false

    // MARK: - Setup

    public init(
        style: Warp.Typography,
        numberOfLines: Int = 1,
        textColor: UIColor = .text,
        withAutoLayout: Bool = false
    ) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        self.style = style
        self.numberOfLines = numberOfLines
        setup(textColor: textColor)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup(textColor: UIColor = .text) {
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))

        isAccessibilityElement = true

        accessibilityLabel = text
        font = style?.uiFont
        self.textColor = textColor
        adjustsFontForContentSizeCategory = true
    }

    // MARK: - Public methods

    public func setTextCopyable(_ isTextCopyable: Bool) {
        self.isTextCopyable = isTextCopyable
        isUserInteractionEnabled = isTextCopyable
    }
}

// MARK: - Copying extension

extension Label {
    public override var canBecomeFirstResponder: Bool { isTextCopyable }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        action == #selector(copy(_:))
    }

    public override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }

    @objc private func handleLongPress(_ recognizer: UIGestureRecognizer) {
        guard recognizer.state == .began else { return }

        becomeFirstResponder()
        let textRect = self.textRect(forBounds: bounds, limitedToNumberOfLines: 1)
        UIMenuController.shared.showMenu(from: self, rect: textRect)
    }
}
