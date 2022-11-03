import Foundation
import UIKit

public final class HTMLStringParserStyleTranslator: HTMLStringParserTranslator {
    private typealias ElementNameAndStyle = (name: String, style: Style)
    public typealias StyleMapper = (_ elementName: String, _ attributes: [String: String]) -> Style?

    private struct StyleInfo {
        let elementName: String
        let style: Style
    }

    let defaultStyle: Style
    private(set) var currentStyle: Style
    private let styleMapper: StyleMapper?
    private var styleStack: [StyleInfo]

    public init(
        defaultStyle: Style,
        styleMapper: StyleMapper?
    ) {
        self.defaultStyle = defaultStyle
        self.styleMapper = styleMapper
        self.styleStack = []
        self.currentStyle = defaultStyle
    }

    public func translate(tokens: [HTMLLexer.Token]) throws -> [StyledText] {
        var styledText: [StyledText] = []
        for token in tokens {
            switch token {
            case .startTag(let name, let attributes, _):
                switch name.lowercased() {
                case "br":
                    styledText.append(StyledText(text: "\n", style: currentStyle))
                    continue
                default:
                    break
                }
                let styleMapper = self.styleMapper ?? defaultStyleMapper
                if let style = styleMapper(name, attributes) {
                    pushStyle(style, elementName: name)
                }
            case .endTag(let name):
                popStyle(elementName: name)
            case .text(let text):
                styledText.append(StyledText(text: text, style: currentStyle))
            default:
                break
            }
        }
        return styledText
    }

    private func defaultStyleMapper(elementName: String, attributes: [String: String]) -> Style? {
        switch elementName.lowercased() {
        case "b", "strong":
            return Style(fontWeight: .bold)
        case "i":
            return Style(italic: true)
        case "s", "del":
            return Style(strikethrough: true)
        case "u":
            return Style(underline: true)
        default:
            return nil
        }
    }

    private func pushStyle(_ style: Style, elementName: String) {
        styleStack.append(StyleInfo(elementName: elementName, style: style))
        currentStyle.update(from: style)
    }

    private func popStyle(elementName: String) {
        for index in (0 ..< styleStack.count).reversed() {
            let info = styleStack[index]
            if info.elementName == elementName {
                styleStack.remove(at: index)
                currentStyle = resolveStyle()
                return
            }
        }
    }

    private func resolveStyle() -> Style {
        var resolvedStyle = defaultStyle
        for info in styleStack {
            resolvedStyle.update(from: info.style)
        }
        return resolvedStyle
    }
}

extension HTMLStringParserStyleTranslator {
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

    public struct StyledText: Equatable {
        public let text: String
        public let style: Style

        public init(text: String, style: Style) {
            self.text = text
            self.style = style
        }
    }
}
