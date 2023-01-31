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
        ToastSwiftUIView(text: "Success", style: .success)
    }
}
