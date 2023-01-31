import SwiftUI

extension ToastSwiftUIView {
    public enum Style {
        case success
        case error
        case successButton
        case errorButton

        var color: Color {
            switch self {
            case .error, .errorButton: return .bgCritical
            default: return .bgSuccess
            }
        }

        var imageAsset: ImageAsset {
            switch self {
            case .error, .errorButton: return .exclamationMarkTriangleMini
            default: return .checkCircleFilledMini
            }
        }
    }

    public enum ButtonStyle {
        case normal
        case promoted
    }
}
