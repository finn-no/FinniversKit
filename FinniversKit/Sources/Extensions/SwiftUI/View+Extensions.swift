//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

extension View {
    public func roundedBorder(radius: CGFloat, width: CGFloat = .spacingXXS, color: Color) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: width)
        )
    }

    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
