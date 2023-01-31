import SwiftUI

public enum Toast {} // Empty for namespacing

// MARK: - Public API

extension Toast {
    public enum Position {
        case top
        case bottom
    }

    public enum Style {
        case success
        case error

        var color: Color {
            switch self {
            case .success: return .bgSuccess
            case .error: return .bgCritical
            }
        }

        var imageAsset: ImageAsset {
            switch self {
            case .success: return .checkCircleFilledMini
            case .error: return .exclamationMarkTriangleMini
            }
        }
    }

    public struct Action {
        public enum ButtonStyle {
            case flat
            case promoted
        }

        public let title: String
        public let buttonStyle: ButtonStyle
        public let action: (() -> Void)

        public init(
            title: String,
            buttonStyle: ButtonStyle = .flat,
            action: @escaping (() -> Void)
        ) {
            self.title = title
            self.buttonStyle = buttonStyle
            self.action = action
        }
    }
}

extension View {
    public func toast(
        text: String,
        style: Toast.Style,
        action: Toast.Action? = nil,
        timeout: TimeInterval = 5,
        position: Toast.Position = .bottom,
        isShowing: Binding<Bool>
    ) -> some View {
        self.modifier(
            ToastViewModifier(
                toastView: .init(text: text, style: style),
                timeout: timeout,
                position: position,
                isShowing: isShowing
            )
        )
    }
}
