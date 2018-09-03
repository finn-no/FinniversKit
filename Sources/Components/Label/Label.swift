//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Label: UILabel {
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
