import SwiftUI

struct FloatingButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let backgroundColorPressed: Color
    let shadowColor: Color
    let shadowOffset: CGSize
    let shadowRadius: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.spacingM)
            .background(configuration.isPressed ? backgroundColorPressed : backgroundColor)
            .clipShape(Capsule())
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
}

struct SwiftUIFloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUI.Button(action: {}, label: {
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(.backgroundPrimary)
                Text("Legg til element")
                    .finnFont(.detail)
                    .foregroundColor(.backgroundPrimary)
            }
        })
        .buttonStyle(FloatingButtonStyle(
            backgroundColor: .background,
            backgroundColorPressed: .backgroundInfoSubtle,
            shadowColor: .black.opacity(0.6),
            shadowOffset: .init(width: 0, height: 5),
            shadowRadius: .spacingS
        ))
    }
}
