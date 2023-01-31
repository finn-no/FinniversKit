import SwiftUI

public struct ToastSwiftUIView: View {
    private let text: String
    private let style: Style
    private let buttonStyle: ButtonStyle

    public init(
        text: String,
        style: Style,
        buttonStyle: ButtonStyle = .normal
    ) {
        self.text = text
        self.style = style
        self.buttonStyle = buttonStyle
    }

    public var body: some View {
        HStack(spacing: .spacingM) {
            Image(style.imageAsset)
            Text(text)
                .finnFont(.body)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.spacingM)
        .background(style.color)
    }
}

struct ToastSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ToastSwiftUIView(text: "Success", style: .success)
    }
}
