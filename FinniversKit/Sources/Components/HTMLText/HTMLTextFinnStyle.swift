import Foundation
import UIKit

extension HTMLStringParserStyleTranslator {
    static var finnStyle: HTMLStringParserStyleTranslator {
        return HTMLStringParserStyleTranslator(defaultStyle: .init(
            font: .body,
            foregroundColor: .textPrimary
        )) { elementName, attributes in
            var style = HTMLStringParserStyleTranslator.Style()
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
