import Foundation
import SwiftUI

extension Toast {
    public struct ViewModel {
        public var text: String
        public var style: Style
        public var action: Action?
        public var timeout: TimeInterval
        public var position: Position

        public init(
            text: String,
            style: Style,
            action: Action? = nil,
            position: Position = .bottom,
            timeout: TimeInterval = 5
        ) {
            self.text = text
            self.style = style
            self.action = action
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
