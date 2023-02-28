import SwiftUI

public struct RibbonViewRepresentable: UIViewRepresentable {
    let ribbonViewModel: RibbonViewModel
    
    public init?(ribbonViewModel: RibbonViewModel?) {
        guard let ribbonViewModel else { return nil }
        self.ribbonViewModel = ribbonViewModel
    }
    
    public func makeUIView(context: Context) -> RibbonView {
        let view = RibbonView(viewModel: ribbonViewModel)
        return view
    }
    
    public func updateUIView(_ uiView: RibbonView, context: Context) {
    }
}
