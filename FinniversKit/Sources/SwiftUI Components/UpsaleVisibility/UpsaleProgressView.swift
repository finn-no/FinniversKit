import SwiftUI
import Warp

struct UpsaleProgressView: View {
    private let lineWidth: CGFloat = 7.0
    private let hairLineSize = 1.0 / UIScreen.main.scale
    private let totalWidth: CGFloat = 52
    private let maxTrimValue: CGFloat = 0.97

    // Category icon
    let icon: UIImage?
    // Circle filling between 0.0 and 1.0
    let progress: CGFloat?

    // According to UI we should trim the circle by 0.03 from right side if its walue == 100
    func calculateProgress() -> CGFloat {
        if let progress {
            return min(maxTrimValue, progress)
        }
        return maxTrimValue
    }

    let gradient = LinearGradient(
        gradient: Gradient(
            colors: [
                Color(UIColor(hex: "#4F46E5")),
                Color(UIColor(hex: "#818CF8"))
            ]
        ),
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
            ZStack {
                // Main Circle with filled color
                Circle()
                    .trim(from: 0.02, to: calculateProgress())
                    .stroke(
                        gradient,
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90)) // start from top
                    .frame(width: totalWidth, height: totalWidth)

                // Inner circle for shadow
                Circle()
                    .stroke(Warp.Token.background,
                            lineWidth: 1
                    )
                    .frame(width: totalWidth - lineWidth, height: totalWidth - lineWidth)
                    .shadow(radius: 2)
                    .clipShape(Circle())

                if let icon {
                    Image(uiImage: icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        .padding([.top, .bottom], Warp.Spacing.spacing100)
    }
}

#Preview {
    UpsaleProgressView(
        icon: UIImage(named: .productTop),
        progress: 1.0
    )
}
