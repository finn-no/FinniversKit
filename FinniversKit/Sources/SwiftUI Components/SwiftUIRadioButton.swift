import SwiftUI

public struct SwiftUIRadioButton: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding public var isSelected: Bool

    private static let size: CGFloat = 16

    private var backgroundColor: Color {
        isSelected ? .textAction : .textSecondary
    }

    private var borderWidth: CGFloat {
        // The selection border looks too wide in dark mode
        let selectedBorderWidth: CGFloat = colorScheme == .dark ? 4 : 5
        return isSelected ? selectedBorderWidth : 1
    }

    private var innerSize: CGFloat {
        SwiftUIRadioButton.size - borderWidth * 2
    }

    public init(isSelected: Binding<Bool>) {
        self._isSelected = isSelected
    }

    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(backgroundColor)
                .frame(width: SwiftUIRadioButton.size, height: SwiftUIRadioButton.size)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isSelected)

            Circle()
                .foregroundColor(.bgPrimary)
                .frame(width: innerSize, height: innerSize)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isSelected)
        }
    }
}


