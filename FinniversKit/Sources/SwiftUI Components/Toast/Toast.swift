import SwiftUI

public enum Toast {} // Empty for namespacing

// MARK: - Public API

extension View {
    public func toast(
        viewModel: Binding<Toast.ViewModel?>
    ) -> some View {
        return self.modifier(
            ToastViewModifier(viewModel: viewModel)
        )
    }
}
