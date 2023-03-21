import SwiftUI

public struct SwiftUIFloatingButton: View {
    @ObservedObject var viewModel: SwiftUIFloatingButtonModel
    @State private var isPressed: Bool = false
    private let style: SwiftUIFloatingButtonStyle
    private let action: () -> Void

    public init(
        style: SwiftUIFloatingButtonStyle = .default,
        viewModel: SwiftUIFloatingButtonModel,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.viewModel = viewModel
        self.action = action
    }

    public var body: some View {
        SwiftUI.Button(action: {
            action()
            isPressed = false
        }, label: {
            HStack {
                viewModel.image
                    .foregroundColor(style.tintColor)
                if let title = viewModel.title {
                    Text(title)
                        .finnFont(.detail)
                        .foregroundColor(style.titleColor)
                }
            }
            .padding(.spacingM)
            .background(isPressed ? style.highlightedBackgroundColor : style.primaryBackgroundColor)
            .clipShape(Capsule())
            .shadow(
                color: style.shadowColor,
                radius: style.shadowRadius,
                x: style.shadowOffset.width,
                y: style.shadowOffset.height
            )
        })
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(LongPressGesture().onChanged { _ in
            isPressed = true
        }.onEnded { _ in
            isPressed = false
        })
    }
}

extension SwiftUIFloatingButton {
    public class SwiftUIFloatingButtonModel: ObservableObject {
        public var title: String?
        public var image: Image?

        public init(title: String, image: Image? = nil) {
            self.title = title
            self.image = image
        }
    }

    public struct SwiftUIFloatingButtonStyle {
        let tintColor: Color
        let titleColor: Color
        let primaryBackgroundColor: Color
        let highlightedBackgroundColor: Color
        let borderWidth: CGFloat
        let borderColor: Color?
        let shadowColor: Color
        let shadowOffset: CGSize
        let shadowRadius: CGFloat

        public static let `default` = SwiftUIFloatingButtonStyle(
            tintColor: Color.btnPrimary,
            titleColor: Color.btnPrimary,
            primaryBackgroundColor: Color.bgPrimary,
            highlightedBackgroundColor: Color.bgSecondary,
            borderWidth: 0,
            borderColor: nil,
            shadowColor: Color.black.opacity(0.6),
            shadowOffset: CGSize(width: 0, height: 5),
            shadowRadius: 8
        )
    }
}

struct SwiftUIFloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIFloatingButton(viewModel: .init(title: "Legg til element", image: .init(systemName: "plus"))) {}
    }
}
