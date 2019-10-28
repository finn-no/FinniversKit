//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct PrimingViewModel {
    public struct Row {
        public let icon: UIImage
        public let title: String
        public let detailText: String

        public init(icon: UIImage, title: String, detailText: String) {
            self.icon = icon
            self.title = title
            self.detailText = detailText
        }
    }

    public let heading: String
    public let buttonTitle: String
    public let rows: [Row]

    public init(heading: String, buttonTitle: String, rows: [Row]) {
        self.heading = heading
        self.buttonTitle = buttonTitle
        self.rows = rows
    }
}
