//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public enum LabelLinkKind {
    case text(String)
    case url(URL)
}

public protocol LabelLinkDelegate: AnyObject {
    func labelDidTapLink(_ label: Label, kind: LabelLinkKind)
}

public class Label: UILabel {

    // MARK: - Public properties

    public private(set) var style: Style?
    public private(set) var isTextCopyable = false
    public weak var linkDelegate: LabelLinkDelegate?

    // MARK: - Setup

    public init(
        style: Style,
        numberOfLines: Int = 1,
        textColor: UIColor = .textPrimary,
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

    private func setup(textColor: UIColor = .textPrimary) {
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))

        isAccessibilityElement = true

        accessibilityLabel = text
        font = style?.font
        self.textColor = textColor
        adjustsFontForContentSizeCategory = true
    }

    // MARK: - Public methods

    public func setTextCopyable(_ isTextCopyable: Bool) {
        self.isTextCopyable = isTextCopyable
        isUserInteractionEnabled = isTextCopyable
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let link = self.link(at: touches) {
            linkDelegate?.labelDidTapLink(self, kind: link)
        } else {
            super.touchesEnded(touches, with: event)
        }
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
        UIMenuController.shared.setTargetRect(textRect, in: self)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
}

// MARK: - Link handling in attributed text
// Based on https://augmentedcode.io/2020/12/20/opening-hyperlinks-in-uilabel-on-ios/

extension Label {
    private var textStorage: NSTextStorage? {
        guard
            let attributedText,
            attributedText.length > 0
        else { return nil }

        // The default font from the label is used when no font is set
        let text = NSMutableAttributedString(attributedString: attributedText)
        text.enumerateAttribute(
            .font,
            in: NSRange(location: 0, length: text.length),
            options: .longestEffectiveRangeNotRequired
        ) { (value, subrange, _) in
            guard value == nil, let font else { return }
            text.addAttribute(.font, value: font, range: subrange)
        }

        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0
        textContainer.size = textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines).size

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage(attributedString: text)
        textStorage.addLayoutManager(layoutManager)

        return textStorage
    }

    private func link(at touches: Set<UITouch>) -> LabelLinkKind? {
        guard
            let textStorage = self.textStorage,
            let touchLocation = touches.sorted(by: { $0.timestamp < $1.timestamp } ).last?.location(in: self)
        else { return nil }

        let layoutManager = textStorage.layoutManagers[0]
        let textContainer = layoutManager.textContainers[0]

        let characterIndex = layoutManager.characterIndex(
            for: touchLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        guard
            characterIndex >= 0,
            characterIndex != NSNotFound
        else { return nil }

        // Glyph index is the closest to the touch, therefore also validate if we actually tapped on the glyph rect
        let glyphRange = layoutManager.glyphRange(
            forCharacterRange: NSRange(location: characterIndex, length: 1),
            actualCharacterRange: nil
        )
        let characterRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        guard
            characterRect.contains(touchLocation),
            let link = textStorage.attribute(.link, at: characterIndex, effectiveRange: nil)
        else { return nil }

        if let text = link as? String {
            return .text(text)
        } else if let url = link as? URL {
            return .url(url)
        }
        return nil
    }
}
