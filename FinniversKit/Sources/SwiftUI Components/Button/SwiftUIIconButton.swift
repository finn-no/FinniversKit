import SwiftUI

public struct SwiftUIIconButton: View {
    public struct Style {
        let icon: ImageAsset
        let iconToggled: ImageAsset
    }

    @Binding public var isToggled: Bool
    private let style: Style

    public init(style: Style, isToggled: Binding<Bool>) {
        self.style = style
        self._isToggled = isToggled
    }

    public var body: some View {
        Image.init(isToggled ? style.iconToggled : style.icon)
            .accessibilityRemoveTraits(.isImage)
            .accessibility(addTraits: isToggled ? [.isButton, .isSelected] : [.isButton])
            .opacity(isToggled ? 0.8 : 1)
    }
}

public extension SwiftUIIconButton.Style {
    static let favorite = SwiftUIIconButton.Style(
        icon: .favouriteAddImg,
        iconToggled: .favouriteAddedImg
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
