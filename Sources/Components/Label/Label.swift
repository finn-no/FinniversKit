//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Label: UILabel {
    // MARK: - Internal properties

    var labelAttributes: [NSAttributedStringKey: Any] {
        guard let style = style else {
            return [:]
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = style.lineSpacing
        paragraphStyle.alignment = textAlignment

        var attributes = [NSAttributedStringKey: Any]()
        attributes[.font] = style.font
        attributes[.paragraphStyle] = paragraphStyle

        if let color = color(for: style) {
            attributes[.foregroundColor] = color
        }

        return attributes
    }

    // MARK: - Setup

    public init(style: Style) {
        super.init(frame: .zero)
        self.style = style
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        accessibilityLabel = text
        font = style?.font

        if let color = color(for: style) {
            textColor = color
        }
    }

    // MARK: - Dependency injection

    public var style: Style?

    // Required for backwards compatibility https://github.com/finn-no/FinniversKit/pull/217
    private func color(for style: Style?) -> UIColor? {
        guard let style = style else {
            return nil
        }

        switch style {
        case .title1, .title2, .title3:
            return .licorice
        case .title4, .title5, .body, .detail:
            return nil
        }
    }
}
