//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Label: UILabel {

    // MARK: - Public properties

    public private(set) var isTextCopyable = false

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
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))

        isAccessibilityElement = true

        accessibilityLabel = text
        font = style?.font
        textColor = .textPrimary
        adjustsFontForContentSizeCategory = true
    }

    // MARK: - Public methods

    public func setTextCopyable(_ isTextCopyable: Bool) {
        self.isTextCopyable = isTextCopyable
        isUserInteractionEnabled = isTextCopyable
    }

    // MARK: - Dependency injection

    public private(set) var style: Style?
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
        UIMenuController.shared.setTargetRect(textRect, in: self)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
}

// MARK: - Support HTML

public extension Label {
    func setText(fromHTMLString htmlString: String, style: [String: String] = [:]) {
        var styledText = htmlString
        for (itemIndex, styleItem) in style {
            styledText = styledText.replacingOccurrences(of: itemIndex, with: styleItem)
        }
        let htmlTemplate = "<span style=\"font-family: \(font!.fontName); font-size: \(font!.pointSize); color: \(textColor.hexString)\">\(styledText)</span>"

        guard
            let data = htmlTemplate.data(using: .utf8),
            let attrStr = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        else {
            return
        }

        attributedText = attrStr
    }
}
