import SwiftUI

public struct SwiftUIIconButton: View {
    public struct Style {
        let color: Color
        let colorToggled: Color
        let icon: UIImage
        let iconToggled: UIImage
    }

    @Binding public var isToggled: Bool
    private let style: Style

    public init(style: Style, isToggled: Binding<Bool>) {
        self.style = style
        self._isToggled = isToggled
    }

    public var body: some View {
        Image.init(uiImage: isToggled ? style.iconToggled : style.icon)
            .renderingMode(.template)
            .foregroundColor(isToggled ? style.colorToggled : style.color)
            .accessibilityRemoveTraits(.isImage)
            .accessibilityAddTraits(isToggled ? [.isButton, .isSelected] : [.isButton])
    }
}

public extension SwiftUIIconButton.Style {
    static let favorite = SwiftUIIconButton.Style(
        color: .iconSubtle,
        colorToggled: .backgroundPrimary,
        icon: UIImage(named: .favoriteDefault),
        iconToggled: UIImage(named: .favoriteActive)
    )
}

struct SwiftUIIconButton_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(true) { binding in
            SwiftUIIconButton(style: .favorite, isToggled: binding)
                .onTapGesture {
                    binding.wrappedValue.toggle()
                }
        }
    }
}
