//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

extension HTMLText {
    public func finnFont(_ style: Label.Style) -> HTMLText {
        font(Font.finnFont(style))
    }
}

extension Text {
    public func finnFont(_ style: Label.Style) -> Text {
        font(Font.finnFont(style))
    }
}

extension Font {
    public static func finnFont(_ style: Label.Style) -> Font {
        Font(style.font)
    }
}

extension View {
    public func finnFont(_ style: Label.Style) -> some View {
        font(.finnFont(style))
    }
}
