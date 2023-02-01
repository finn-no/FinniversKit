import SwiftUI

public struct ToastSwiftUIView: View {
    private let text: String
    private let style: Toast.Style
    private let actionButton: Toast.ActionButton?

    public init(
        text: String,
        style: Toast.Style,
        actionButton: Toast.ActionButton? = nil
    ) {
        self.text = text
        self.style = style
        self.actionButton = actionButton
    }

    public var body: some View {
        HStack(spacing: .spacingM) {
            Image(style.imageAsset)
            Text(text)
                .finnFont(.body)
                .foregroundColor(.textToast)
                .padding(.vertical, .spacingM)
            Spacer()
            if let actionButton {
                ActionButtonView(actionButton: actionButton, style: style)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, .spacingM)
        .background(style.color)
    }
}

struct ToastSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .spacingM) {
            ToastSwiftUIView(text: "Success", style: .success)
            ToastSwiftUIView(text: "Action success, with a pretty long text which should wrap nicely", style: .success, actionButton: .init(title: "Undo", action: {}))
            ToastSwiftUIView(text: "Action success", style: .success, actionButton: .init(title: "Action", buttonStyle: .promoted, action: {}))

            ToastSwiftUIView(text: "Error", style: .error)
            ToastSwiftUIView(text: "Action error", style: .error, actionButton: .init(title: "Undo", action: {}))
            ToastSwiftUIView(text: "Action error", style: .error, actionButton: .init(title: "Undo", buttonStyle: .promoted, action: {}))
        }
    }
}
