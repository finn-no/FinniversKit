import SwiftUI

public struct LoadingSwiftUIViewModifier: ViewModifier {
    @Binding var isActive: Bool {
        didSet {
            showWorkItem?.cancel()
            showWorkItem = nil
            hideWorkItem?.cancel()
            hideWorkItem = nil

            if !isActive {
                withAnimation {
                    isVisible = false
                }
            }
        }
    }

    private let displayMode: LoadingSwiftUIView.DisplayMode
    private let message: String?
    private let showSuccess: Bool
    private let showAfter: Double?
    private let hideAfter: Double?

    @State private var isVisible: Bool = false
    @State private var showWorkItem: DispatchWorkItem?
    @State private var hideWorkItem: DispatchWorkItem?

    public init(
        isActive: Binding<Bool>,
        displayMode: LoadingSwiftUIView.DisplayMode = .fullscreen,
        message: String? = nil,
        showSuccess: Bool = false,
        showAfter: Double? = nil,
        hideAfter: Double? = nil
    ) {
        self._isActive = isActive
        self.displayMode = displayMode
        self.message = message
        self.showSuccess = showSuccess
        self.showAfter = showAfter
        self.hideAfter = hideAfter
    }

    public func body(content: Content) -> some View {
        if isActive {
            if isVisible {
                content
                    .overlay(LoadingSwiftUIView(mode: displayMode, message: message, showSuccess: showSuccess))
                    .onAppear {
                        guard let hideAfter else { return }
                        let hideWork = DispatchWorkItem {
                            withAnimation {
                                self.isActive = false
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
        isActive: Binding<Bool>,
        displayMode: LoadingSwiftUIView.DisplayMode = .fullscreen,
        message: String? = nil,
        showSuccess: Bool = false,
        showAfter: Double? = nil,
        hideAfter: Double? = nil
    ) -> some View {
        modifier(LoadingSwiftUIViewModifier(
            isActive: isActive,
            displayMode: displayMode,
            message: message,
            showSuccess: showSuccess,
            showAfter: showAfter,
            hideAfter: hideAfter
        ))
    }
}
