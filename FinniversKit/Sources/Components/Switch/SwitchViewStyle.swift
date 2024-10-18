//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public struct SwitchViewStyle {
    public let titleLabelStyle: Warp.Typography
    public let titleLabelTextColor: UIColor
    public let detailLabelStyle: Warp.Typography
    public let detailLabelTextColor: UIColor

    public static var `default` = SwitchViewStyle(
        titleLabelStyle: .bodyStrong,
        titleLabelTextColor: .textSubtle,
        detailLabelStyle: .detail,
        detailLabelTextColor: .textSubtle
    )

    public init(titleLabelStyle: Warp.Typography, titleLabelTextColor: UIColor, detailLabelStyle: Warp.Typography, detailLabelTextColor: UIColor) {
        self.titleLabelStyle = titleLabelStyle
        self.titleLabelTextColor = titleLabelTextColor
        self.detailLabelStyle = detailLabelStyle
        self.detailLabelTextColor = detailLabelTextColor
    }
}
