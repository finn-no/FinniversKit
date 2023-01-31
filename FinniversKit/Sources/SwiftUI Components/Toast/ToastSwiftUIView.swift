import SwiftUI

public struct ToastSwiftUIView: View {
    private let text: String
    private let style: Style
    private let action: Action?

    public init(
        text: String,
        style: Style,
        action: Action? = nil
    ) {
        self.text = text
        self.style = style
        self.action = action
    }

    public var body: some View {
        HStack(spacing: .spacingM) {
            Image(style.imageAsset)
            Text(text)
                .finnFont(.body)
                .padding(.vertical, .spacingM)
            Spacer()
            if let action {
                ToastActionButton(action: action, style: style)
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
            ToastSwiftUIView(text: "Action success, with a pretty long text which should wrap nicely", style: .success, action: .init(title: "Undo", action: {}))
            ToastSwiftUIView(text: "Action success", style: .success, action: .init(title: "Action", buttonStyle: .promoted, action: {}))

            ToastSwiftUIView(text: "Error", style: .error)
            ToastSwiftUIView(text: "Action error", style: .error, action: .init(title: "Undo", action: {}))
            ToastSwiftUIView(text: "Action error", style: .error, action: .init(title: "Undo", buttonStyle: .promoted, action: {}))
        }
    }
}
