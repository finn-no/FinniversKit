import SwiftUI

public struct SwiftUIIconButton: View {
    public struct Style {
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
        Image.init(uiImage: isToggled ? style.icon : style.iconToggled)
            .accessibilityRemoveTraits(.isImage)
            .accessibilityAddTraits(isToggled ? [.isButton, .isSelected] : [.isButton])
            .opacity(isToggled ? 0.8 : 1)
    }
}

public extension SwiftUIIconButton.Style {
    static let favorite = SwiftUIIconButton.Style(
        icon: .brandFavouriteAddImg,
        iconToggled: .brandFavouriteAddedImg
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
