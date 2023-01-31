import SwiftUI

struct ToastActionButton: View {
    let action: ToastSwiftUIView.Action
    let style: ToastSwiftUIView.Style

    var body: some View {
        Group {
            switch action.buttonStyle {
            case .normal:
                SwiftUI.Button(action.title, action: action.action)
                    .buttonStyle(InlineFlatStyle())
            case .promoted:
                SwiftUI.Button(action.title, action: action.action)
                    .buttonStyle(ToastPromotedButtonStyle(style: style))
            }
        }
    }
}

struct ToastPromotedButtonStyle: ButtonStyle {
    let style: ToastSwiftUIView.Style
    private let cornerRadius: CGFloat = .spacingL

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .finnFont(.bodyStrong)
            .padding(.vertical, .spacingS)
            .padding(.horizontal, .spacingM)
            .foregroundColor(.textToast)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white, lineWidth: 2)
            )
    }

    var backgroundColor: Color {
        switch style {
        case .success: return .accentPea
        case .error: return .init(UIColor.red400)
        }
    }
}

struct ToastActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .spacingL) {
            ToastActionButton(action: .init(title: "Undo", buttonStyle: .normal, action: {}), style: .success)
            ToastActionButton(action: .init(title: "Undo", buttonStyle: .promoted, action: {}), style: .success)
            ToastActionButton(action: .init(title: "Undo", buttonStyle: .promoted, action: {}), style: .error)
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.bgSuccess)
    }
}
