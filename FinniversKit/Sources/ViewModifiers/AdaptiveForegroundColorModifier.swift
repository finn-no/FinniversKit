import SwiftUI

// Aplying a .foregroundColor modifier with DNA colors, e.g. .foregroundColor makes the animations glitchy.
// When there's a possibility that the view's position can change, it's advised to apply the updated
// .foregroundColor(dynamicColor:) modifier to avoid animation issues.
public struct AdaptiveForegroundColorModifier: ViewModifier {
    public var dynamicColor: UIColor

    @Environment(\.colorScheme) private var colorScheme

    public func body(content: Content) -> some View {
        content.foregroundColor(resolvedColor)
    }

    private var resolvedColor: Color {
        switch colorScheme {
        case .light:
            return Color(dynamicColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)))
        case .dark:
            return Color(dynamicColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)))
        }
    }
}

public extension View {
    func foregroundColor(
        dynamicColor: UIColor
    ) -> some View {
        modifier(AdaptiveForegroundColorModifier(dynamicColor: dynamicColor))
    }
}
