import Foundation
import SwiftUI
import UIKit

extension HTMLStringSwiftUIStyleTranslator {
    static func finnStyle(
        font: Font?,
        foregroundColor: Color?
    ) -> HTMLStringSwiftUIStyleTranslator {
        return .init(defaultStyle: .init(
            font: .body,
            foregroundColor: .textPrimary
        )) { elementName, attributes in
            var style = HTMLStringSwiftUIStyleTranslator.Style()
            switch elementName.lowercased() {
            case "b", "strong":
                style.fontWeight = .bold
            case "del", "s":
                style.strikethrough = true
            case "i":
                style.italic = true
            case "span":
                if let styleAttrib = attributes["style"], styleAttrib == "color:tjt-price-highlight" {
                    style.foregroundColor = .textCritical
                }
            case "u":
                style.underline = true
            default:
                break
            }
            return style
        }
    }
}

extension HTMLStringUIKitStyleTranslator {
    static func finnStyle(
        font: UIFont?,
        foregroundColor: UIColor?
    ) -> HTMLStringUIKitStyleTranslator {
        return .init(defaultStyle: .init(
            font: .body,
            foregroundColor: .textPrimary
        )) { elementName, attributes in
            var style = HTMLStringUIKitStyleTranslator.Style()
            switch elementName.lowercased() {
            case "b", "strong":
                style.fontWeight = .bold
            case "del", "s":
                style.strikethrough = true
            case "i":
                style.italic = true
            case "span":
                if let styleAttrib = attributes["style"], styleAttrib == "color:tjt-price-highlight" {
                    style.foregroundColor = .textCritical
                }
            case "u":
                style.underline = true
            default:
                break
            }
            return style
        }
    }
}
