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

public struct SwiftUIFloatingButton_Previews: PreviewProvider {
    public init() {}

    public static var previews: some View {
        SwiftUI.Button(action: {}, label: {
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(.btnPrimary)
                Text("Legg til element")
                    .finnFont(.detail)
                    .foregroundColor(.btnPrimary)
            }
        })
        .buttonStyle(FloatingButtonStyle(
            backgroundColor: .bgPrimary,
            backgroundColorPressed: .bgSecondary,
            shadowColor: .black.opacity(0.6),
            shadowOffset: .init(width: 0, height: 5),
            shadowRadius: .spacingS
        ))
    }
}
