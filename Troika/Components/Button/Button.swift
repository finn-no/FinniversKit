//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class Button: UIButton {

    // MARK: - Internal properties

    // MARK: - External properties

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        // Perform setup
    }

    // MARK: - Superclass Overrides

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        // Add custom subviews
        // Layout your custom views
    }

    // MARK: - Dependency injection

    // MARK: - Private
}
