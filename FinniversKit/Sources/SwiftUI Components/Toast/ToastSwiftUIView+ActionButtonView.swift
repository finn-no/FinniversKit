import SwiftUI

extension ToastSwiftUIView {
    struct ActionButtonView: View {
        let actionButton: Toast.ActionButton
        let style: Toast.Style

        var body: some View {
            Group {
                switch actionButton.style {
                case .flat:
                    SwiftUI.Button(actionButton.title, action: actionButton.action)
                        .buttonStyle(InlineFlatStyle())
                case .promoted:
                    SwiftUI.Button(actionButton.title, action: actionButton.action)
                        .buttonStyle(PromotedStyle(style: style))
                }
            }
        }
    }
}

extension ToastSwiftUIView.ActionButtonView {
    struct PromotedStyle: ButtonStyle {
        let style: Toast.Style
        private let cornerRadius: CGFloat = .spacingL

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .finnFont(.bodyStrong)
                .padding(.vertical, .spacingS)
                .padding(.horizontal, .spacingM)
                .foregroundColor(.text)
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
            ToastSwiftUIView.ActionButtonView(actionButton: .init(title: "Undo", buttonStyle: .flat, action: {}), style: .success)
            ToastSwiftUIView.ActionButtonView(actionButton: .init(title: "Undo", buttonStyle: .promoted, action: {}), style: .success)
            ToastSwiftUIView.ActionButtonView(actionButton: .init(title: "Undo", buttonStyle: .promoted, action: {}), style: .error)
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.backgroundPositiveSubtle)
    }
}
