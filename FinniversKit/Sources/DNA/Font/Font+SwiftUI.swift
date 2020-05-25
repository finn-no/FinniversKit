//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension Text {
    public func finnFont(_ style: Label.Style) -> Text {
        font(Font.finnFont(style))
    }
}

@available(iOS 13.0, *)
extension Font {
    public static func finnFont(_ style: Label.Style) -> Font {
        Font(style.font)
    }
}

@available(iOS 13.0, *)
extension View {
    public func finnFont(_ style: Label.Style) -> some View {
        font(.finnFont(style))
    }
}
