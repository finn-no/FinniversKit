import Foundation
import SwiftUI

extension Toast {
    public struct ViewModel {
        public let text: String
        public let style: Style
        public let actionButton: ActionButton?
        public let timeout: TimeInterval
        public let position: Position

        public init(
            text: String,
            style: Style,
            actionButton: ActionButton? = nil,
            position: Position = .bottom,
            timeout: TimeInterval = 5
        ) {
            self.text = text
            self.style = style
            self.actionButton = actionButton
            self.position = position
            self.timeout = timeout
        }
    }

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

    public struct ActionButton {
        public enum Style {
            case flat
            case promoted
        }

        public let title: String
        public let style: Style
        public let action: (() -> Void)

        public init(
            title: String,
            buttonStyle: Style = .flat,
            action: @escaping (() -> Void)
        ) {
            self.title = title
            self.style = buttonStyle
            self.action = action
        }
    }
}

extension Toast.ViewModel: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.text == rhs.text
        && lhs.style == rhs.style
        && lhs.timeout == rhs.timeout
        && lhs.position == rhs.position
    }
}
