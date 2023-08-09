import SwiftUI

public final class GenericErrorViewModel {
    private(set) var title: String
    private(set) var description: String?
    private(set) var buttonTitle: String?
    private(set) var action: (() -> Void)?

    public init(
        title: String,
        description: String? = nil,
        buttonTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.action = action
    }
}

public struct GenericErrorViewModifier: ViewModifier {
    @Binding var viewModel: GenericErrorViewModel?

    public func body(content: Content) -> some View {
        ZStack {
            content

            if let viewModel {
                GenericErrorSwiftUIView(viewModel: viewModel)
            }
        }
    }
}

public struct GenericErrorSwiftUIView: UIViewRepresentable {
    let viewModel: GenericErrorViewModel

    public init(viewModel: GenericErrorViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIView(context: Context) -> FinniversKit.EmptyView {
        let genericView = FinniversKit.EmptyView(shapeType: .default)
        genericView.header = viewModel.title
        genericView.message = viewModel.description ?? ""
        genericView.actionButtonTitle = viewModel.buttonTitle ?? ""
        genericView.delegate = context.coordinator
        genericView.translatesAutoresizingMaskIntoConstraints = true
        return genericView
    }

    public func updateUIView(_ uiView: FinniversKit.EmptyView, context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public class Coordinator: NSObject, EmptyViewDelegate {
        let parent: GenericErrorSwiftUIView

        init(parent: GenericErrorSwiftUIView) {
            self.parent = parent
        }

        public func emptyView(_ emptyView: FinniversKit.EmptyView, didSelectActionButton button: FinniversKit.Button) {
            parent.viewModel.action?()
        }

        public func emptyView(_ emptyView: FinniversKit.EmptyView, didMoveObjectView view: UIView) {
        }
    }
}

public extension View {
    func genericErrorView(for viewModel: Binding<GenericErrorViewModel?>) -> some View {
        modifier(GenericErrorViewModifier(viewModel: viewModel))
    }
}
