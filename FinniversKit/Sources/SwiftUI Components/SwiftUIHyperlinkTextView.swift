import SwiftUI

public struct SwiftUIHyperlinkTextView: View {
    let viewModel: HyperlinkTextViewViewModel
    @State var size: CGSize?

    public init(viewModel: HyperlinkTextViewViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        GeometryReader { proxy in
            HyperLinkTextViewRepresentable(
                viewModel: viewModel,
                proposedSize: proxy.size
            )
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(key: ChildSizeKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(ChildSizeKey.self) { newSize in
                size = newSize
            }
        }
        .frame(width: size?.width, height: size?.height)
    }
}

private struct ChildSizeKey: PreferenceKey {
    static var defaultValue: CGSize?

    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
    }
}

private struct HyperLinkTextViewRepresentable: UIViewRepresentable {
    let viewModel: HyperlinkTextViewViewModel
    let proposedSize: CGSize

    func makeUIView(context: Context) -> HyperlinkTextView {
        HyperlinkTextView(withAutoLayout: false)
    }

    func updateUIView(_ uiView: HyperlinkTextView, context: Context) {
        uiView.configure(with: viewModel)
        uiView.frame.size = CGSize(width: proposedSize.width, height: proposedSize.height)
        uiView.layoutIfNeeded()

        uiView.setContentHuggingPriority(.required, for: .vertical)
        uiView.setContentHuggingPriority(.required, for: .horizontal)
    }
}

struct SwiftUIHyperlinkTextView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HyperlinkTextViewViewModel(
            text: "Ved å godta en forespørsel aksepterer du også <tos>vilkårene for Fiks ferdig frakt og betaling hos FINN</tos>",
            hyperlinks: [
                HyperlinkTextViewViewModel.Hyperlink(
                    hyperlink: "tos",
                    action: "blablabla"
                )
            ]
        )
        SwiftUIHyperlinkTextView(viewModel: viewModel)
    }
}
