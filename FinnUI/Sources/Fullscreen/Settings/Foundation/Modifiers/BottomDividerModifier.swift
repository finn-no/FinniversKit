//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

@available(iOS 13.0.0, *)
public struct BottomDividerModifier: ViewModifier {
    let show: Bool
    let inset: EdgeInsets

    public func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    Spacer()
                    Divider().padding(inset)
                }
            }
        }.listRowInsets(EdgeInsets())
    }
}

@available(iOS 13.0.0, *)
extension View {
    public func bottomDivider(
        _ show: Bool,
        inset: EdgeInsets = EdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0)
    ) -> some View {
        modifier(BottomDividerModifier(show: show, inset: inset))
    }
}
