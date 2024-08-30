import Foundation
import SwiftUI

public final class HTMLStringSwiftUIStyleTranslator: HTMLStringParserTranslator {
    public typealias StyleMapper = (_ elementName: String, _ attributes: [HTMLToken.TagAttribute]) -> Style?

    public struct StyledText: Equatable {
        public let text: String
        public let style: Style
        public let attributes: [Attribute]?

        public init(text: String, style: Style, attributes: [Attribute]? = nil) {
            self.text = text
            self.style = style
            self.attributes = attributes
        }

        public var url: URL? {
            attributes?.compactMap { attribute in
                switch attribute {
                case .url(let value):
                    return value
                }
            }
            .first
        }
    }

    private let styleMapper: StyleMapper?
    private(set) var styleStack: HTMLStringStyleStack<Style>
    private(set) var attributeStack: HTMLAttributeStack<Attribute>

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
        self.attributeStack = HTMLAttributeStack()
    }

    public func translate(tokens: [HTMLToken]) throws -> [StyledText] {
        var styledText: [StyledText] = []
        for token in tokens {
            switch token {
            case .tagStart(let name, let attributes, _):
                switch name.lowercased() {
                case "br":
                    styledText.append(StyledText(text: "\n", style: styleStack.currentStyle))
                    continue
                case "a":
                    if let urlString = attributes.first(where: { $0.name.lowercased() == "href"})?.value,
                       let url = URL(string: urlString) {
                        attributeStack.pushAttribute(.url(value: url), elementName: name)
                    }
                default:
                    break
                }
                let styleMapper = self.styleMapper ?? defaultStyleMapper
                if let style = styleMapper(name, attributes) {
                    styleStack.pushStyle(style, elementName: name)
                }
            case .tagEnd(let name):
                attributeStack.popAttribute(elementName: name)
                styleStack.popStyle(elementName: name)
            case .text(let text):
                if let lastAttribute = attributeStack.peek() {
                    styledText.append(.init(text: text, style: styleStack.currentStyle, attributes: [lastAttribute]))
                } else {
                    styledText.append(.init(text: text, style: styleStack.currentStyle, attributes: nil))
                }
            default:
                break
            }
        }
        return styledText
    }

    private func defaultStyleMapper(elementName: String, attributes: [HTMLToken.TagAttribute]) -> Style? {
        switch elementName.lowercased() {
        case "b", "strong":
            return .init(fontWeight: .bold)
        case "i":
            return .init(italic: true)
        case "s", "del":
            return .init(strikethrough: true)
        case "u":
            return .init(underline: true)
        case "a":
            return .init(underline: true)
        default:
            return nil
        }
    }
}

extension HTMLStringSwiftUIStyleTranslator {
    public struct Style: Equatable {
        public var font: Font?
        public var fontWeight: Font.Weight?
        public var foregroundColor: Color?
        public var italic: Bool?
        public var strikethrough: Bool?
        public var strikethroughColor: Color?
        public var underline: Bool?
        public var underlineColor: Color?

        public init(
            font: Font? = nil,
            fontWeight: Font.Weight? = nil,
            foregroundColor: Color? = nil,
            italic: Bool? = nil,
            strikethrough: Bool? = nil,
            strikethroughColor: Color? = nil,
            underline: Bool? = nil,
            underlineColor: Color? = nil
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

extension HTMLStringSwiftUIStyleTranslator {
    public enum Attribute: Equatable {
        /*
         For now we just have a URL attribute here (which is read from the href attribute of an anchor tag)
         but this could be extended if so needed
         */
        case url(value: URL)
    }
}
