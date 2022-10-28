import Foundation
import SwiftUI

extension HTMLStringParserTranslator where Output == Text {
    static var finnTextView: HTMLStringParserTextViewTranslator {
        return HTMLStringParserTextViewTranslator(defaultStyle: .init(
            font: .finnFont(.body),
            foregroundColor: .textPrimary
        )) { elementName, attributes in
            guard
                elementName == "span",
                let styleAttrib = attributes["style"],
                styleAttrib == "color:tjt-price-highlight"
            else { return nil }
            return .init(foregroundColor: .textCritical)
        }
    }
}
