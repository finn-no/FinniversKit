import Foundation
import SwiftUI
import UIKit

extension HTMLStringSwiftUIStyleTranslator {
    static func finnStyle(
        font: Font?,
        foregroundColor: Color?
    ) -> HTMLStringSwiftUIStyleTranslator {
        return .init(defaultStyle: .init(
            font: font,
            foregroundColor: foregroundColor
        )) { elementName, attributes in
            var style = HTMLStringSwiftUIStyleTranslator.Style()
            let element = HTMLElement(elementName)
            switch element {
            case .b, .strong:
                style.fontWeight = .bold
            case .del, .s:
                style.strikethrough = true
            case .i:
                style.italic = true
            case .span:
                for (name, value) in attributes {
                    switch name {
                    case "style":
                        if value == "color:tjt-price-highlight" {
                            style.foregroundColor = .textCritical
                        }
                    default:
                        break
                    }
                }
            case .u:
                style.underline = true
            default:
                break
            }
            return style
        }
    }
}

extension HTMLStringUIKitStyleTranslator {
    public typealias SpanMapper = (_ attributes: [String: String], _ currentStyle: inout Style) -> Void

    static func finnStyle(
        font: UIFont?,
        foregroundColor: UIColor?,
        spanMapper: @escaping SpanMapper //= { _ in nil }
    ) -> HTMLStringUIKitStyleTranslator {
        return .init(defaultStyle: .init(
            font: font,
            foregroundColor: foregroundColor
        )) { elementName, attributes in
            var style = HTMLStringUIKitStyleTranslator.Style()
            let element = HTMLElement(elementName)
            switch element {
            case .b, .strong:
                style.fontWeight = .bold
            case .del, .s:
                style.strikethrough = true
            case .span:
                spanMapper(attributes, &style)
            case .u:
                style.underline = true
            default:
                break
            }
            return style
        }
    }
}
