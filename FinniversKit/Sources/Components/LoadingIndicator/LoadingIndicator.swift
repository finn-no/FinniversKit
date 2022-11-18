import SwiftUI

public struct LoadingIndicator: UIViewRepresentable {
    private var isAnimating: Bool
    private var startDelay: Double

    public init(
        isAnimating: Bool = true,
        startDelay: Double = 0.0
    ) {
        self.isAnimating = isAnimating
        self.startDelay = startDelay
    }

    public func makeUIView(context: Context) -> LoadingIndicatorView {
        LoadingIndicatorView(frame: .zero)
    }

    public func updateUIView(_ uiView: LoadingIndicatorView, context: Context) {
        if isAnimating {
            if startDelay == 0.0 {
                uiView.startAnimating()
            } else {
                uiView.startAnimating(after: startDelay)
            }
        } else {
            uiView.stopAnimating()
        }
    }

    public mutating func animating(
        _ isAnimating: Bool,
        delay: Double = 0.0
    ) -> Self {
        self.isAnimating = isAnimating
        self.startDelay = delay
        return self
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
            .frame(width: 50, height: 50)
    }
}
