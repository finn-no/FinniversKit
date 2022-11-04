import Foundation
import UIKit

public final class HTMLStringUIKitStyleTranslator: HTMLStringParserTranslator {
    public typealias StyleMapper = (_ elementName: String, _ attributes: [String: String]) -> Style?

    public struct StyledText: Equatable {
        public let text: String
        public let style: Style

        public init(text: String, style: Style) {
            self.text = text
            self.style = style
        }
    }

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

    public func translate(tokens: [HTMLLexer.Token]) throws -> [StyledText] {
        var styledText: [StyledText] = []
        for token in tokens {
            switch token {
            case .startTag(let name, let attributes, _):
                switch name.lowercased() {
                case "br":
                    styledText.append(StyledText(text: "\n", style: styleStack.currentStyle))
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
                styledText.append(StyledText(text: text, style: styleStack.currentStyle))
            default:
                break
            }
        }
        return styledText
    }

    private func defaultStyleMapper(elementName: String, attributes: [String: String]) -> Style? {
        switch elementName.lowercased() {
        case "b", "strong":
            return .init(fontWeight: .bold)
        case "i":
            return .init(italic: true)
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
        public var italic: Bool?
        public var strikethrough: Bool?
        public var strikethroughColor: UIColor?
        public var underline: Bool?
        public var underlineColor: UIColor?

        public init(
            font: UIFont? = nil,
            fontWeight: UIFont.Weight? = nil,
            foregroundColor: UIColor? = nil,
            italic: Bool? = nil,
            strikethrough: Bool? = nil,
            strikethroughColor: UIColor? = nil,
            underline: Bool? = nil,
            underlineColor: UIColor? = nil
        ) {
            self.font = font
            self.fontWeight = fontWeight
            self.foregroundColor = foregroundColor
            self.italic = italic
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
            if let italic = otherStyle.italic {
                self.italic = italic
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
