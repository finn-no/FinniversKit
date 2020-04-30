//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

@available(iOS 13.0.0, *)
public struct BottomDividerModifier: ViewModifier {
    let show: Bool

    public func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    Spacer()
                    Divider().padding(0)
                }
            }
        }.listRowInsets(EdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0))
    }
}

@available(iOS 13.0.0, *)
extension View {
    public func bottomDivider(_ show: Bool) -> some View {
        modifier(BottomDividerModifier(show: show))
    }
}
