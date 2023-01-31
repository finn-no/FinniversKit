import SwiftUI
import FinniversKit

struct ToastSwiftUIDemoView: View {
    @State var showToastFromBottom: Bool = false
    @State var showToastFromTop: Bool = false

    var body: some View {
        VStack(spacing: .spacingM) {
            SwiftUI.Button("Animate from top") {
                showToastFromTop = true
            }

            ToastSwiftUIView(text: "Success", style: .success)
            ToastSwiftUIView(text: "Action success, with a pretty long text which should wrap nicely", style: .success, action: .init(title: "Undo", action: {}))
            ToastSwiftUIView(text: "Action success", style: .success, action: .init(title: "Action", buttonStyle: .promoted, action: {}))

            ToastSwiftUIView(text: "Error", style: .error)
            ToastSwiftUIView(text: "Action error", style: .error, action: .init(title: "Undo", action: {}))
            ToastSwiftUIView(text: "Action error", style: .error, action: .init(title: "Undo", buttonStyle: .promoted, action: {}))

            SwiftUI.Button("Animate from bottom") {
                showToastFromBottom = true
            }
        }
        .toast(
            view: ToastSwiftUIView(text: "Animated from bottom", style: .success),
            isShowing: $showToastFromBottom,
            position: .bottom
        )
        .toast(
            view: ToastSwiftUIView(text: "Animated from top", style: .success),
            isShowing: $showToastFromTop,
            position: .top
        )
    }
}

struct ToastSwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ToastSwiftUIDemoView()
    }
}
