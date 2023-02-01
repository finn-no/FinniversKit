import SwiftUI

public enum Toast {} // Empty for namespacing

// MARK: - Public API

extension View {
    public func toast(
        text: String,
        style: Toast.Style,
        actionButton: Toast.ActionButton? = nil,
        timeout: TimeInterval = 5,
        position: Toast.Position = .bottom,
        isShowing: Binding<Bool>
    ) -> some View {
        self.modifier(
            ToastViewModifier(
                toastView: .init(text: text, style: style, actionButton: actionButton),
                timeout: timeout,
                position: position,
                isShowing: isShowing
            )
        )
    }

    public func toast(
        viewModel: Toast.ViewModel,
        isShowing: Binding<Bool>
    ) -> some View {
        return self.modifier(
            ToastViewModifier(
                toastView: .init(text: viewModel.text, style: viewModel.style, actionButton: viewModel.actionButton),
                timeout: viewModel.timeout,
                position: viewModel.position,
                isShowing: isShowing
            )
        )
    }
}
