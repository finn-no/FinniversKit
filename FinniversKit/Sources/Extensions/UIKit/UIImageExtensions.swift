//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

extension UIImage {
    convenience init?(frameworkImageNamed name: String) {
        self.init(named: name, in: .finniversKit, compatibleWith: nil)
    }

    static func warpSwipeActionDisc(icon: UIImage, fill: UIColor) -> UIImage {
        let baseDiameter: CGFloat = 40
        let baseIconSize: CGFloat = 20
        let diameter = UIFontMetrics.default.scaledValue(for: baseDiameter)
        let iconSize = diameter * (baseIconSize / baseDiameter)
        let size = CGSize(width: diameter, height: diameter)
        let renderer = UIGraphicsImageRenderer(size: size)
        let composed = renderer.image { context in
            fill.setFill()
            context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
            let iconRect = CGRect(
                x: (diameter - iconSize) / 2,
                y: (diameter - iconSize) / 2,
                width: iconSize,
                height: iconSize
            )
            icon.withTintColor(Warp.UIToken.iconInverted, renderingMode: .alwaysOriginal).draw(in: iconRect)
        }
        return composed.withRenderingMode(.alwaysOriginal)
    }
}
