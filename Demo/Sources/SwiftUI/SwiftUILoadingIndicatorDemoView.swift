import FinniversKit
import SwiftUI
import DemoKit
import Warp

struct SwiftUILoadingIndicatorDemoView: View {
    var body: some View {
        VStack(spacing: Warp.Spacing.spacing800) {
            SwiftUILoadingIndicator()
                .frame(width: 40, height: 40)

            SwiftUILoadingIndicator(delay: 2)
                .frame(width: 40, height: 40)
        }
    }
}

struct SwiftUILoadingIndicatorDemoView_Previews: PreviewProvider, Demoable {
    static var previews: some View {
        SwiftUILoadingIndicatorDemoView()
    }
}
