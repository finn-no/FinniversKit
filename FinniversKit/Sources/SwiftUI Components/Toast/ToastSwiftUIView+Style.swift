import SwiftUI

extension ToastSwiftUIView {
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

    public enum ButtonStyle {
        case normal
        case promoted
    }
}
