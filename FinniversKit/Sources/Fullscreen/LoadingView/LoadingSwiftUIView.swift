import SwiftUI

public struct LoadingSwiftUIView: View {
    public enum DisplayMode: Equatable {
        case fullscreen
        case boxed
    }

    private let displayMode: DisplayMode
    private let message: String?
    private let showSuccess: Bool

    @State private var loadingIndicatorScale: CGFloat = 0.7
    private let animationDuration: Double = 0.3
    private let initialScale: CGFloat = 0.7
    private let loadingIndicatorSize: CGFloat = 40
    private var isFullscreen: Bool { displayMode == .fullscreen }
    private var boxMaxSize: CGFloat { isFullscreen ? .greatestFiniteMagnitude : 120 }
    private let boxMinSize: CGFloat = 120
    private var textColor: Color { isFullscreen ? .textPrimary : .textTertiary }

    public init(
        mode: DisplayMode = .fullscreen,
        message: String? = nil,
        showSuccess: Bool = false
    ) {
        self.displayMode = mode
        self.message = message
        self.showSuccess = showSuccess
    }

    public var body: some View {
        ZStack {
            backgroundView

            VStack(spacing: .spacingS) {
                // Since the indicator view starts at a smaller size we must wrap it for fixed size
                VStack {
                    if showSuccess {
                        Image(.checkmarkBig)
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(isFullscreen ? .accentSecondaryBlue : .iconTertiary)
                            .scaleEffect(loadingIndicatorScale)
                            .onAppear {
                                loadingIndicatorScale = initialScale
                                withAnimation(.linear(duration: animationDuration)) {
                                    loadingIndicatorScale = 1.0
                                }
                            }
                    } else {
                        SwiftUILoadingIndicator()
                            .scaleEffect(loadingIndicatorScale)
                            .onAppear {
                                loadingIndicatorScale = initialScale
                                withAnimation(.linear(duration: animationDuration)) {
                                    loadingIndicatorScale = 1.0
                                }
                            }
                    }
                }
                .frame(width: loadingIndicatorSize, height: loadingIndicatorSize)

                if let message {
                    Text(message)
                        .finnFont(.bodyStrong)
                        .foregroundColor(textColor)
                }
            }
            .ignoresSafeArea(edges: [])
            .padding(.spacingM)
        }
        .frame(minWidth: boxMinSize, maxWidth: boxMaxSize, minHeight: boxMinSize, maxHeight: boxMaxSize)
        .cornerRadius(isFullscreen ? 0 : .spacingM)
        .ignoresSafeArea()
        .disabled(isFullscreen)
        .transition(.opacity.animation(.linear(duration: animationDuration)))
    }

    private var backgroundView: some View {
        let color: Color = isFullscreen ? .bgPrimary : .black
        return color.opacity(0.8)
    }
}

struct SwiftUILoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                VStack {
                    Text("Some text in background")
                    Text("Another text in background")
                    Text("Yet another text in background")
                }
                LoadingSwiftUIView(mode: .fullscreen, message: "Loading")
            }

            LoadingSwiftUIView(mode: .boxed, message: "Loading")

            LoadingSwiftUIView(mode: .fullscreen, message: "Done", showSuccess: true)
        }
    }
}
