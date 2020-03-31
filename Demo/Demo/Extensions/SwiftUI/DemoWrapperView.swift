//
//  Copyright © 2020 FINN AS. All rights reserved.
//
#if canImport(SwiftUI) && DEBUG
import SwiftUI

/// A generic UIViewRepresentable to present UIViews in Xcode previews, intended for DemoViews
struct DemoWrapperView<DemoView: UIView>: UIViewRepresentable {
    let view: DemoView

    init(view: DemoView) {
        self.view = view
    }

    func makeUIView(context: Context) -> DemoView { view }

    func updateUIView(_ uiView: DemoView, context: Context) {}
}
#endif
