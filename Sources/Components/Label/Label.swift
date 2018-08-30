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
        attributes[.foregroundColor] = UIColor.licorice

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
        textColor = .licorice
    }

    // MARK: - Dependency injection

    public private(set) var style: Style?
}
