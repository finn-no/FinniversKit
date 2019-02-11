//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

/// Just you regular UIButton, but making sure the the touch-target at least fulfills the minimum size-requirements detailed in Apple's HIG
public class HIGFriendlyButton: UIButton {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden || !isUserInteractionEnabled || alpha < .leastNormalMagnitude { return nil }

        let size = bounds.size
        let additionalWidth = max(44, size.width) - size.width
        let additionalHeight = max(44, size.height) - size.height
        let largerFrame = bounds.insetBy(dx: -additionalWidth/2, dy: -additionalHeight/2)
        return largerFrame.contains(point) ? self : nil
    }
}
