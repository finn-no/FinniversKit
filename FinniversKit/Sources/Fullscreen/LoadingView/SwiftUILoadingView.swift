import SwiftUI

public struct SwiftUILoadingView: View {
    public enum DisplayMode {
        case fullscreen
        case boxed
    }

    public enum DisplayType {
        case loading
        case success
    }

    @State private var loadingIndicatorCurrentSize: CGFloat = 40 * 0.7
    @State private var loadingOpacity: CGFloat = 0

    private let displayMode: DisplayMode
    private let displayType: DisplayType
    private let message: String?
    private let successDelay: Double?

    private let animationDuration: Double = 0.3
    private let initialScaleSize = CGSize(width: 0.7, height: 0.7)
    private let loadingIndicatorSize: CGFloat = 40
    private var isFullscreen: Bool { displayMode == .fullscreen }
    private var boxMaxSize: CGFloat { isFullscreen ? .greatestFiniteMagnitude : 120 }
    private let boxMinSize: CGFloat = 120
    private var textColor: Color { isFullscreen ? .textPrimary : .textTertiary }

    public init(
        mode: DisplayMode = .fullscreen,
        type: DisplayType = .loading,
        message: String? = nil,
        successAfter: Double? = nil
    ) {
        self.displayMode = mode
        self.displayType = type
        self.message = message
        self.successDelay = successAfter
    }

    public var body: some View {
        ZStack {
            backgroundView

            VStack(spacing: .spacingS) {
                ZStack {
                    indicatorView
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
        .opacity(loadingOpacity)
        .ignoresSafeArea()
        .disabled(isFullscreen)
        .onAppear {
            // For some reason we need to dispatch to get a correct initial animation
            DispatchQueue.main.async {
                withAnimation(.linear(duration: animationDuration)) {
                    loadingIndicatorCurrentSize = loadingIndicatorSize
                    loadingOpacity = 1
                }
            }
        }
    }

    private var backgroundView: some View {
        let color: Color = isFullscreen ? .bgPrimary : .black
        return color.opacity(0.8)
    }

    @ViewBuilder
    private var indicatorView: some View {
        if displayType == .success {
            Image(.checkmarkBig)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(isFullscreen ? .accentSecondaryBlue : .iconTertiary)
                .frame(width: loadingIndicatorCurrentSize, height: loadingIndicatorCurrentSize)
        } else {
            SwiftUILoadingIndicator()
                .frame(width: loadingIndicatorCurrentSize, height: loadingIndicatorCurrentSize)
        }
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
                SwiftUILoadingView(mode: .fullscreen, type: .loading, message: "Loading")
            }

            SwiftUILoadingView(mode: .boxed, type: .loading, message: "Loading")

            SwiftUILoadingView(mode: .fullscreen, type: .success, message: "Done")
        }
    }
}
