import SwiftUI
import Warp

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
        private let cornerRadius: CGFloat = Warp.Spacing.spacing300

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(from: .bodyStrong)
                .padding(.vertical, Warp.Spacing.spacing100)
                .padding(.horizontal, Warp.Spacing.spacing200)
                .foregroundColor(.textLink)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.border, lineWidth: 2)
                )
        }

        var backgroundColor: Color {
            .background
        }
    }
}

struct ToastSwiftUIViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Warp.Spacing.spacing300) {
            ToastSwiftUIView.ActionButtonView(actionButton: .init(title: "Undo", buttonStyle: .flat, action: {}), style: .success)
            ToastSwiftUIView.ActionButtonView(actionButton: .init(title: "Undo", buttonStyle: .promoted, action: {}), style: .success)
            ToastSwiftUIView.ActionButtonView(actionButton: .init(title: "Undo", buttonStyle: .promoted, action: {}), style: .error)
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.backgroundPositiveSubtle)
    }
}
