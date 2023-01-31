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
    }

    public enum ButtonStyle {
        case normal
        case promoted
    }
}
