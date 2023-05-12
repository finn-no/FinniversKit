import SwiftUI

public struct SwiftUICheckBox: View {
    @Binding var isChecked: Bool

    private let size: CGFloat
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat

    private var fillOpacity: CGFloat {
        isChecked ? 0 : 1
    }

    private var checkMarkTrimEnd: CGFloat {
        isChecked ? 1 : 0
    }

    private var checkMarkScale: CGFloat {
        isChecked ? 1 : .zero
    }

    private var fillinSize: CGSize {
        isChecked ? .zero : CGSize(width: size, height: size)
    }

    public init(
        isChecked: Binding<Bool>,
        size: CGFloat = 16,
        cornerRadius: CGFloat = 2,
        borderWidth: CGFloat = 1
    ) {
        self._isChecked = isChecked
        self.size = size
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }

    public var body: some View {
        ZStack {
            // Blue background
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.textAction)
                .frame(width: size, height: size)

            // Fill area over the background, shrinks to a point when checked
            RoundedRectangle(cornerRadius: isChecked ? size : cornerRadius)
                .fill(Color.bgPrimary)
                .frame(
                    width: fillinSize.width,
                    height: fillinSize.height
                )
                .animation(.easeOut(duration: 0.15), value: fillinSize)

            // The gray border for the control, fades when checked
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.textSecondary, lineWidth: borderWidth)
                .frame(
                    width: size,
                    height: size
                )
                .opacity(fillOpacity)
                .animation(.easeOut, value: isChecked)

            // The checkmark shape, animates trim when checked, and shrinks when unchecked
            Checkmark()
                .trim(from: 0, to: checkMarkTrimEnd)
                .stroke(
                    Color.white,
                    style: .init(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .animation(.easeOut(duration: 0.15).delay(0.15), value: checkMarkTrimEnd)
                .frame(
                    width: size,
                    height: size
                )
                .scaleEffect(checkMarkScale)
        }
        .onTapGesture {
            isChecked.toggle()
        }
    }
}

private struct Checkmark: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height

        var path = Path()
        path.move(to: .init(x: 0.28 * width, y: 0.55 * height))
        path.addLine(to: .init(x: 0.45 * width, y: 0.7 * height))
        path.addLine(to: .init(x: 0.72 * width, y: 0.35 * height))
        return path
    }
}

struct SwiftUICheckBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StatefulPreviewWrapper(false) {
                SwiftUICheckBox(isChecked: $0)
            }
            StatefulPreviewWrapper(true) {
                SwiftUICheckBox(isChecked: $0)
            }
        }
    }
}

