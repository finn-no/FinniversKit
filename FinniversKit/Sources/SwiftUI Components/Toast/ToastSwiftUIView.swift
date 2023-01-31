import SwiftUI

public struct ToastSwiftUIView: View {
    private let style: Style
    private let buttonStyle: ButtonStyle

    public init(
        style: Style,
        buttonStyle: ButtonStyle = .normal
    ) {
        self.style = style
        self.buttonStyle = buttonStyle
    }

    public var body: some View {
        Text("Toast")
            .background(style.color)
    }
}

struct ToastSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ToastSwiftUIView(style: .success)
    }
}
