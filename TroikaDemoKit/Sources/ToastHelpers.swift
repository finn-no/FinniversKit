import Foundation
import Troika

public enum ToastDataModel: ToastPresentable {
    case success
    case successImage
    case error
    case successButton
    case errorButton
    case multiline
    
    public var type: ToastType {
        switch self {
        case .success: return ToastType.success
        case .successImage: return ToastType.sucesssImage
        case .error: return ToastType.error
        case .successButton: return ToastType.successButton
        case .errorButton: return ToastType.errorButton
        case .multiline: return ToastType.success
        }
    }
    
    public var messageTitle: String {
        switch self {
        case .success: return "Success message with icon"
        case .successImage: return "Success message with thumbnail"
        case .error: return "Error toast with message that spans over multiple lines"
        case .successButton: return "Toast message over multiple lines with action"
        case .errorButton: return "Error message with action"
        case .multiline: return "Toast with a message that spans over multiple lines"
        }
    }
    
    public var actionButtonTitle: String? {
        switch self {
        case .successButton: return "Action"
        case .errorButton: return "Retry"
        default: return nil
        }
    }
    
    public var imageThumbnail: UIImage? {
        switch self {
        case .successImage: return UIImage(named: "eiendom", in: .troikaDemoKit, compatibleWith: nil)
        default: return nil
        }
    }
}
