import SwiftUI

public struct LoadingSwiftUIViewModifier: ViewModifier {
    private let showAfter: Double?
    private let hideAfter: Double?

    @Binding var viewModel: LoadingSwiftUIViewModel? {
        didSet {
            showWorkItem?.cancel()
            showWorkItem = nil
            hideWorkItem?.cancel()
            hideWorkItem = nil

            if viewModel == nil {
                withAnimation {
                    isVisible = false
                }
            }
        }
    }

    @State private var isVisible: Bool = false
    @State private var showWorkItem: DispatchWorkItem?
    @State private var hideWorkItem: DispatchWorkItem?

    public init(
        viewModel: Binding<LoadingSwiftUIViewModel?>,
        showAfter: Double? = nil,
        hideAfter: Double? = nil
    ) {
        self._viewModel = viewModel
        self.showAfter = showAfter
        self.hideAfter = hideAfter
    }

    public func body(content: Content) -> some View {
        if let viewModel {
            if isVisible {
                content
                    .overlay(LoadingSwiftUIView(viewModel: viewModel))
                    .onAppear {
                        guard let hideAfter else { return }
                        let hideWork = DispatchWorkItem {
                            withAnimation {
                                self.viewModel = nil
                            }
                        }
                        hideWorkItem = hideWork
                        DispatchQueue.main.asyncAfter(deadline: .now() + hideAfter, execute: hideWork)
                    }
            } else {
                content
                    .onAppear {
                        let showWork = DispatchWorkItem {
                            withAnimation {
                                self.isVisible = true
                            }
                        }
                        showWorkItem = showWork
                        let showDelay = showAfter ?? 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + showDelay, execute: showWork)
                    }
            }
        } else {
            content
        }
    }
}

extension View {
    public func loadingOverlay(
        viewModel: Binding<LoadingSwiftUIViewModel?>,
        showAfter: Double? = nil,
        hideAfter: Double? = nil
    ) -> some View {
        modifier(LoadingSwiftUIViewModifier(
            viewModel: viewModel,
            showAfter: showAfter,
            hideAfter: hideAfter
        ))
    }
}

/*
struct LoadingSwiftUIViewModifier_Previews: PreviewProvider {
    struct DemoView: View {
        @State var loadingViewModel: LoadingSwiftUIViewModel?

        let fullscreenViewModel = LoadingSwiftUIViewModel(mode: .fullscreen, message: "Loading")

        var body: some View {
            VStack {
                Text("Hello World!")

                SwiftUI.Button(action: toggleViewModel) {
                    Text(loadingViewModel == nil ? "Show loading view" : "Hide loading view")
                }

            }
            .loadingOverlay(viewModel: $loadingViewModel)
        }

        func toggleViewModel() {
            withAnimation {
                loadingViewModel = loadingViewModel == nil ? fullscreenViewModel : nil
            }
        }
    }

    static var previews: some View {
        DemoView()
    }
}
*/
