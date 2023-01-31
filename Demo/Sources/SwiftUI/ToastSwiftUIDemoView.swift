import SwiftUI
import FinniversKit

struct ToastSwiftUIDemoView: View {
    var body: some View {
        VStack(spacing: .spacingM) {
            ToastSwiftUIView(style: .success)
            ToastSwiftUIView(style: .successButton)
            ToastSwiftUIView(style: .successButton, buttonStyle: .promoted)

            ToastSwiftUIView(style: .error)
            ToastSwiftUIView(style: .errorButton)
            ToastSwiftUIView(style: .errorButton, buttonStyle: .promoted)
        }
    }
}

struct ToastSwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ToastSwiftUIDemoView()
    }
}
