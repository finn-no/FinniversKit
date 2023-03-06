import SwiftUI

public extension Text {
    public static func optional(_ str: (any StringProtocol)?) -> some View {
        guard let str = str else { return AnyView(Text("").isHidden(true, remove: true)) }
        return AnyView(Text(str))
    }
}
