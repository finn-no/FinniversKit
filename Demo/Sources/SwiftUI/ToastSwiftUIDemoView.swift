import SwiftUI
import FinniversKit

struct ToastSwiftUIDemoView: View {
    var body: some View {
        VStack(spacing: .spacingM) {
            ToastSwiftUIView(text: "Success", style: .success)
            ToastSwiftUIView(text: "Action success, with a pretty long text which should wrap nicely", style: .successButton)
            ToastSwiftUIView(text: "Action success", style: .successButton, buttonStyle: .promoted)

            ToastSwiftUIView(text: "Error", style: .error)
            ToastSwiftUIView(text: "Action error", style: .errorButton)
            ToastSwiftUIView(text: "Action error", style: .errorButton, buttonStyle: .promoted)
        }
    }
}

struct ToastSwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ToastSwiftUIDemoView()
    }
}
