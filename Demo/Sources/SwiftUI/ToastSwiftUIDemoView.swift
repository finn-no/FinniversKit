import SwiftUI
import FinniversKit

struct ToastSwiftUIDemoView: View {
    var body: some View {
        VStack(spacing: .spacingM) {
            ToastSwiftUIView(style: .success)
            ToastSwiftUIView(style: .successButton)

            ToastSwiftUIView(style: .error)

        }
    }
}

struct ToastSwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ToastSwiftUIDemoView()
    }
}
