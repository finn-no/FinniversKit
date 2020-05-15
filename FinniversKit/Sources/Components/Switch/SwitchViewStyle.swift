//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct SwitchViewStyle {
    public let titleLabelStyle: Label.Style
    public let titleLabelTextColor: UIColor
    public let detailLabelStyle: Label.Style
    public let detailLabelTextColor: UIColor

    public static var `default` = SwitchViewStyle(
        titleLabelStyle: .bodyStrong,
        titleLabelTextColor: .textSecondary,
        detailLabelStyle: .detail,
        detailLabelTextColor: .textSecondary
    )

    public init(titleLabelStyle: Label.Style, titleLabelTextColor: UIColor, detailLabelStyle: Label.Style, detailLabelTextColor: UIColor) {
        self.titleLabelStyle = titleLabelStyle
        self.titleLabelTextColor = titleLabelTextColor
        self.detailLabelStyle = detailLabelStyle
        self.detailLabelTextColor = detailLabelTextColor
    }
}
