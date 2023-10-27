import SwiftUI

public struct SwiftUIRadioButton: View {
    @Binding public var isSelected: Bool

    private var size: CGFloat = 16
    private var borderWidth: CGFloat = 1
    private var borderColor: Color = .textSubtle
    private var selectionColor: Color = .textLink
    private var selectionScale: CGFloat = 7/16

    private var backgroundColor: Color {
        isSelected ? selectionColor : borderColor
    }

    private var innerSize: CGFloat {
        isSelected ? size * selectionScale : size - borderWidth * 2
    }

    public init(isSelected: Binding<Bool>) {
        self._isSelected = isSelected
    }

    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(backgroundColor)
                .frame(width: size, height: size)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isSelected)

            Circle()
                .foregroundColor(.background)
                .frame(width: innerSize, height: innerSize)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isSelected)
        }
    }

    public func size(_ size: CGFloat) -> Self {
        var view = self
        view.size = size
        return view
    }

    public func borderWidth(_ borderWidth: CGFloat) -> Self {
        var view = self
        view.borderWidth = borderWidth
        return view
    }

    public func borderColor(_ borderColor: Color) -> Self {
        var view = self
        view.borderColor = borderColor
        return view
    }

    public func selectionColor(_ selectionColor: Color) -> Self {
        var view = self
        view.selectionColor = selectionColor
        return view
    }

    public func selectionScale(_ selectionScale: CGFloat) -> Self {
        var view = self
        view.selectionScale = selectionScale
        return view
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
