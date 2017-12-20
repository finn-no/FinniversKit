//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// A struct that holds the insets when laying out a view.
public struct Insets {
    let top: CGFloat
    let leading: CGFloat
    let bottom: CGFloat
    let trailing: CGFloat

    public static var zero: Insets {
        return Insets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }

    public init(top: Int = 0, leading: Int = 0, bottom: Int = 0, trailing: Int = 0) {
        self.init(top: CGFloat(top), leading: CGFloat(leading), bottom: CGFloat(bottom), trailing: CGFloat(trailing))
    }

    public init(top: Double = 0, leading: Double = 0, bottom: Double = 0, trailing: Double = 0) {
        self.init(top: CGFloat(top), leading: CGFloat(leading), bottom: CGFloat(bottom), trailing: CGFloat(trailing))
    }

    public init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.top = top
        self.leading = leading

        // Required in order to ensure correct use against AutoLayout constants,
        // where negative values are required in order to add a bottom and trailing inset.
        self.bottom = bottom > 0 ? bottom * -1 : bottom
        self.trailing = trailing > 0 ? trailing * -1 : trailing
    }
}
