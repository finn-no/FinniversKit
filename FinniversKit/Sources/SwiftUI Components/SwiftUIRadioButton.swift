import SwiftUI

public struct SwiftUIRadioButton: View {
    @Binding public var isSelected: Bool

    private let size: CGFloat
    private let borderWidth: CGFloat
    private let selectionScale: CGFloat

    private var backgroundColor: Color {
        isSelected ? .textAction : .textSecondary
    }

    private var innerSize: CGFloat {
        isSelected ? size * selectionScale : size - borderWidth * 2
    }

    public init(
        isSelected: Binding<Bool>,
        size: CGFloat = 16,
        borderWidth: CGFloat = 1,
        selectionScale: CGFloat = 7/16
    ) {
        self._isSelected = isSelected
        self.size = size
        self.borderWidth = borderWidth
        self.selectionScale = selectionScale
    }

    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(backgroundColor)
                .frame(width: size, height: size)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isSelected)

            Circle()
                .foregroundColor(.bgPrimary)
                .frame(width: innerSize, height: innerSize)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isSelected)
        }
    }
}

struct SwiftUIRadioButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StatefulPreviewWrapper(true) { binding in
                SwiftUIRadioButton(isSelected: binding)
                    .onTapGesture {
                        binding.wrappedValue.toggle()
                    }
            }

            StatefulPreviewWrapper(false) { binding in
                SwiftUIRadioButton(isSelected: binding)
                    .onTapGesture {
                        binding.wrappedValue.toggle()
                    }
            }
        }
    }
}
