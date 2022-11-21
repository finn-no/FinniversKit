import SwiftUI

public struct SwiftUIRadioButton: View {
    @Binding public var isSelected: Bool

    private static let size: CGFloat = 16

    private var backgroundColor: Color {
        isSelected ? .textAction : .textSecondary
    }

    private var borderWidth: CGFloat {
        isSelected ? 5 : 1
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
                .foregroundColor(Color.white)
                .frame(width: innerSize, height: innerSize)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isSelected)
        }
    }
}


