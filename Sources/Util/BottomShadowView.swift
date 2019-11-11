//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class BottomShadowView: TopShadowView {
    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        // Make shadow to be on bottom
        let radius = TopShadowView.maxShadowRadius
        let rect = CGRect(x: 0, y: bounds.maxY - radius, width: bounds.width, height: radius)
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }
}
