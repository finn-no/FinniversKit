import SwiftUI

extension ToastSwiftUIView {
    struct ActionButton: View {
        let action: Action
        let style: Style

        var body: some View {
            Group {
                switch action.buttonStyle {
                case .normal:
                    SwiftUI.Button(action.title, action: action.action)
                        .buttonStyle(InlineFlatStyle())
                case .promoted:
                    SwiftUI.Button(action.title, action: action.action)
                        .buttonStyle(PromotedStyle(style: style))
                }
            }
        }
    }
}

extension ToastSwiftUIView.ActionButton {
    struct PromotedStyle: ButtonStyle {
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
}

struct ToastSwiftUIViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .spacingL) {
            ToastSwiftUIView.ActionButton(action: .init(title: "Undo", buttonStyle: .normal, action: {}), style: .success)
            ToastSwiftUIView.ActionButton(action: .init(title: "Undo", buttonStyle: .promoted, action: {}), style: .success)
            ToastSwiftUIView.ActionButton(action: .init(title: "Undo", buttonStyle: .promoted, action: {}), style: .error)
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.bgSuccess)
    }
}
