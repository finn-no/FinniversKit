import SwiftUI

public struct SwiftUILoadingIndicator: View {
    private struct ProgressCircle: Shape {
        var startAngle: Angle
        var endAngle: Angle
        let lineWidth: CGFloat

        var animatableData: AnimatablePair<Double, Double> {
            get { AnimatablePair(startAngle.animatableData, endAngle.animatableData) }
            set {
                startAngle.animatableData = newValue.first
                endAngle.animatableData = newValue.second
            }
        }

        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(
                center: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2),
                radius: min(rect.size.width, rect.size.height) / 2 - lineWidth / 2,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            return path
        }
    }

    @State private var isAnimating: Bool = false

    @State private var progressCircleStartAngle: Angle = .degrees(0)

    @State private var progressCircleEndAngle: Angle = .degrees(1)

    @State private var rotationAngle: Angle = .degrees(-90)

    private let animationDuration: CGFloat = 2.5

    private let lineWidth: CGFloat = 4

    private var loadingIndicatorBackgroundColor: Color {
        Color(red: 221/255, green: 232/255, blue: 250/255)
    }

    public init() {}

    public var body: some View {
        ZStack {
            Circle()
                .strokeBorder(loadingIndicatorBackgroundColor, lineWidth: lineWidth)

            ProgressCircle(startAngle: progressCircleStartAngle, endAngle: progressCircleEndAngle, lineWidth: lineWidth)
                .stroke(Color.accentSecondaryBlue, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(rotationAngle)
                .onAppear {
                    isAnimating = true
                    startRotationAnimation()
                    startStrokeAnimation()
                }
                .onDisappear {
                    isAnimating = false
                }
        }
    }

    private func startRotationAnimation() {
        guard isAnimating else { return }

        let rotationAnimation = Animation
            .linear(duration: animationDuration)
            .repeatForever(autoreverses: false)

        withAnimation(rotationAnimation) {
            rotationAngle = rotationAngle + .degrees(360)
        }
    }

    private func startStrokeAnimation() {
        guard isAnimating else { return }

        progressCircleStartAngle = .degrees(0)
        progressCircleEndAngle = .degrees(1)
        let halfDuration = animationDuration / 2

        withAnimation(.easeInOut(duration: halfDuration)) {
            progressCircleEndAngle = .degrees(361)
        }

        // SwiftUI doesn't support chaining animations yet, so we simulate it by
        // dispatching animations after the duration of each has ended.
        DispatchQueue.main.asyncAfter(deadline: .now() + halfDuration) {
            withAnimation(.easeInOut(duration: halfDuration)) {
                progressCircleStartAngle = .degrees(360)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            startStrokeAnimation()
        }
    }
}

struct SwiftUILoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUILoadingIndicator()
            .frame(width: 50, height: 50)
    }
}
