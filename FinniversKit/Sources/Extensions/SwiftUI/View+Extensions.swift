//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

extension View {
    public func roundedBorder(radius: CGFloat, width: CGFloat = .spacingXXS, color: Color) -> some View {
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
