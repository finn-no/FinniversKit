import Foundation
import UIKit

public final class HTMLStringUIKitStyleTranslator: HTMLStringParserTranslator {
    public typealias StyleMapper = (_ elementName: String, _ attributes: [String: String]) -> Style?

    private let styleMapper: StyleMapper?
    private var styleStack: HTMLStringStyleStack<Style>

    public init(
        defaultStyle: Style,
        styleMapper: StyleMapper?
    ) {
        self.styleMapper = styleMapper
        self.styleStack = HTMLStringStyleStack(
            defaultStyle: defaultStyle,
            updateHandler: { style, otherStyle in
                style.update(from: otherStyle)
            }
        )
    }

    public func translate(tokens: [HTMLLexer.Token]) throws -> NSAttributedString {
        var finalString = "".applyStyle(styleStack.currentStyle)
        for token in tokens {
            switch token {
            case .startTag(let name, let attributes, _):
                switch name.lowercased() {
                case "br":
                    finalString = finalString + "\n".applyStyle(styleStack.currentStyle)
                    continue
                default:
                    break
                }
                let styleMapper = self.styleMapper ?? defaultStyleMapper
                if let style = styleMapper(name, attributes) {
                    styleStack.pushStyle(style, elementName: name)
                }
            case .endTag(let name):
                styleStack.popStyle(elementName: name)
            case .text(let text):
                let string = text.applyStyle(styleStack.currentStyle)
                finalString = finalString + string
            default:
                break
            }
        }
        return finalString
    }

    private func defaultStyleMapper(elementName: String, attributes: [String: String]) -> Style? {
        switch elementName.lowercased() {
        case "b", "strong":
            return .init(fontWeight: .bold)
        case "s", "del":
            return .init(strikethrough: true)
        case "u":
            return .init(underline: true)
        default:
            return nil
        }
    }
}

extension HTMLStringUIKitStyleTranslator {
    public struct Style: Equatable {
        public var font: UIFont?
        public var fontWeight: UIFont.Weight?
        public var foregroundColor: UIColor?
        public var strikethrough: Bool?
        public var strikethroughColor: UIColor?
        public var underline: Bool?
        public var underlineColor: UIColor?

        public init(
            font: UIFont? = nil,
            fontWeight: UIFont.Weight? = nil,
            foregroundColor: UIColor? = nil,
            strikethrough: Bool? = nil,
            strikethroughColor: UIColor? = nil,
            underline: Bool? = nil,
            underlineColor: UIColor? = nil
        ) {
            self.font = font
            self.fontWeight = fontWeight
            self.foregroundColor = foregroundColor
            self.strikethrough = strikethrough
            self.strikethroughColor = strikethroughColor
            self.underline = underline
            self.underlineColor = underlineColor
        }

        public mutating func update(from otherStyle: Style) {
            if let font = otherStyle.font {
                self.font = font
            }
            if let fontWeight = otherStyle.fontWeight {
                self.fontWeight = fontWeight
            }
            if let foregroundColor = otherStyle.foregroundColor {
                self.foregroundColor = foregroundColor
            }
            if let strikethrough = otherStyle.strikethrough {
                self.strikethrough = strikethrough
            }
            if let strikethroughColor = otherStyle.strikethroughColor {
                self.strikethroughColor = strikethroughColor
            }
            if let underline = otherStyle.underline {
                self.underline = underline
            }
            if let underlineColor = otherStyle.underlineColor {
                self.underlineColor = underlineColor
            }
        }
    }
}

private extension String {
    func applyStyle(_ style: HTMLStringUIKitStyleTranslator.Style) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]
        var fontTraits = UIFontDescriptor.SymbolicTraits()
        if let fontWeight = style.fontWeight {
            switch fontWeight {
            case .bold:
                fontTraits = fontTraits.union(.traitBold)
            default:
                break
            }
        }
        if let foregroundColor = style.foregroundColor {
            attributes[.foregroundColor] = foregroundColor
        }
        if let strikeThrough = style.strikethrough, strikeThrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        if let underline = style.underline, underline {
            attributes[.underlineStyle] = NSUnderlineStyle.single
        }
        if let font = style.font {
            let fontDescriptor = font.fontDescriptor.withSymbolicTraits(fontTraits) ?? font.fontDescriptor
            attributes[.font] = UIFont(descriptor: fontDescriptor, size: font.pointSize)
        }
        return NSAttributedString(string: self, attributes: attributes)
    }
}
