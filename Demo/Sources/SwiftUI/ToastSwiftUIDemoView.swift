import SwiftUI
import FinniversKit
import DemoKit

struct ToastSwiftUIDemoView: View {
    @State var topToastViewModel: Toast.ViewModel? = nil
    @State var bottomToastViewModel: Toast.ViewModel? = nil

    var body: some View {
        VStack(spacing: .spacingM) {
            SwiftUI.Button("Animate from top") {
                topToastViewModel = .init(
                    text: "Animated from top",
                    style: .success,
                    position: .top
                )
            }

            ToastSwiftUIView(text: "Success", style: .success)
            ToastSwiftUIView(text: "Action success, with a pretty long text which should wrap nicely", style: .success, actionButton: .init(title: "Undo", action: {}))
            ToastSwiftUIView(text: "Action success", style: .success, actionButton: .init(title: "Action", buttonStyle: .promoted, action: {}))

            ToastSwiftUIView(text: "Error", style: .error)
            ToastSwiftUIView(text: "Action error", style: .error, actionButton: .init(title: "Undo", action: {}))
            ToastSwiftUIView(text: "Action error", style: .error, actionButton: .init(title: "Undo", buttonStyle: .promoted, action: {}))

            SwiftUI.Button("Animate from bottom") {
                bottomToastViewModel = .init(
                    text: "Animated from bottom",
                    style: .success,
                    position: .bottom
                )
            }
        }
        .toast(viewModel: $topToastViewModel)
        .toast(viewModel: $bottomToastViewModel)
    }
}

struct ToastSwiftUIDemoView_Previews: PreviewProvider, Demoable {
    static var previews: some View {
        ToastSwiftUIDemoView()
    }
}
