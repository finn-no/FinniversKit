import Foundation
import SwiftUI

public final class HTMLParserTextViewTranslator: HTMLParserTranslator {
    private typealias ElementNameAndStyle = (name: String, style: Style)
    public typealias StyleMapper = (_ elementName: String, _ attributes: [String: String]) -> Style?

    private struct StyleInfo {
        let elementName: String
        let style: Style
    }

    private let defaultStyle: Style
    private let styleMapper: StyleMapper?
    private var styleStack: [StyleInfo]
    private var currentStyle: Style

    public init(
        defaultStyle: Style,
        styleMapper: StyleMapper?
    ) {
        self.defaultStyle = defaultStyle
        self.styleMapper = styleMapper
        self.styleStack = []
        self.currentStyle = defaultStyle
    }

    public func translate(tokens: [HTMLParser.Token]) throws -> Text {
        var finalTextView = Text("").applyStyle(defaultStyle)

        for token in tokens {
            switch token {
            case .comment(_):
                break
            case .elementBegin(let name, let attributes):
                switch name.lowercased() {
                case "br":
                    finalTextView = finalTextView + Text("\n").applyStyle(currentStyle)
                    continue
                default:
                    break
                }
                if let style = styleMapper?(name, attributes) {
                    pushStyle(style, elementName: name)
                } else if let style = defaultStyleMapper(elementName: name, attributes: attributes) {
                    pushStyle(style, elementName: name)
                }
            case .elementEnd(let name):
                popStyle(elementName: name)
            case .text(let text):
                let textView = Text(text).applyStyle(currentStyle)
                finalTextView = finalTextView + textView
            }
        }

        return finalTextView
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

extension HTMLParserTextViewTranslator {
    public struct Style {
        public var font: Font?
        public var fontWeight: Font.Weight?
        public var foregroundColor: Color?
        public var italic: Bool
        public var strikethrough: Bool
        public var strikethroughColor: Color?
        public var underline: Bool
        public var underlineColor: Color?

        public init(
            font: Font? = nil,
            fontWeight: Font.Weight? = nil,
            foregroundColor: Color? = nil,
            italic: Bool = false,
            strikethrough: Bool = false,
            strikethroughColor: Color? = nil,
            underline: Bool = false,
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
            self.italic = otherStyle.italic
            self.strikethrough = otherStyle.strikethrough
            if let strikethroughColor = otherStyle.strikethroughColor {
                self.strikethroughColor = strikethroughColor
            }
            self.underline = otherStyle.underline
            if let underlineColor = otherStyle.underlineColor {
                self.underlineColor = underlineColor
            }
        }
    }
}

extension Text {
    fileprivate func applyStyle(_ style: HTMLParserTextViewTranslator.Style) -> Text {
        var text = self
        if let font = style.font {
            text = text.font(font)
        }
        if let fontWeight = style.fontWeight {
            text = text.fontWeight(fontWeight)
        }
        if let foregroundColor = style.foregroundColor {
            text = text.foregroundColor(foregroundColor)
        }
        if style.italic {
            text = text.italic()
        }
        if style.strikethrough {
            text = text.strikethrough(color: style.strikethroughColor)
        }
        if style.underline {
            text = text.underline(color: style.underlineColor)
        }
        return text
    }
}
