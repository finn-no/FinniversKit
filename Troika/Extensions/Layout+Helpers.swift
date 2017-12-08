//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// A struct that holds the insets when laying out a view.
public struct EdgeInsets {
    // Replace with NSDirectionalEdgeInsets when going for > iOS 11.
    // The reason for using this instead of UIEdgeInsets is because in UIEdgeInsets uses left and right instead of
    // leading and trailing.

    let top: CGFloat
    let leading: CGFloat
    let bottom: CGFloat
    let trailing: CGFloat

    public static var zero: EdgeInsets {
        return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }

    public init(top: Int = 0, leading: Int = 0, bottom: Int = 0, trailing: Int = 0) {
        self.init(top: CGFloat(top), leading: CGFloat(leading), bottom: CGFloat(bottom), trailing: CGFloat(trailing))
    }

    public init(top: Double = 0, leading: Double = 0, bottom: Double = 0, trailing: Double = 0) {
        self.init(top: CGFloat(top), leading: CGFloat(leading), bottom: CGFloat(bottom), trailing: CGFloat(trailing))
    }

    public init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.top = top > 0 ? top : top * -1
        self.leading = leading > 0 ? leading : leading * -1
        self.bottom = bottom > 0 ? bottom : bottom * -1
        self.trailing = trailing > 0 ? trailing : trailing * -1
    }
}
