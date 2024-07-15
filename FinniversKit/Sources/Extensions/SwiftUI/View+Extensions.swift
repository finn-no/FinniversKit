//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI
import Warp

extension View {
    public func roundedBorder(radius: CGFloat, width: CGFloat = Warp.Spacing.spacing25, color: Color) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(color, lineWidth: width)
        )
    }

    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }

    @ViewBuilder public func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
