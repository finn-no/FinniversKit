import Foundation
import Troika

public enum ToastDataModel: ToastPresentable {
    case success
    case successImage
    case error
    case button
    case multiline
    
    public var type: ToastType {
        switch self {
        case .success: return ToastType.success
        case .successImage: return ToastType.sucesssImage
        case .error: return ToastType.error
        case .button: return ToastType.button
        case .multiline: return ToastType.success
        }
    }
    
    public var messageTitle: String {
        switch self {
        case .success: return "Success message with icon"
        case .successImage: return "Success message with thumbnail"
        case .error: return "Error message with icon"
        case .button: return "A long toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action Toast message with action"
        case .multiline: return "Toast with a message that spans over multiple lines"
        }
    }
    
    public var actionButtonTitle: String? {
        switch self {
        case .button: return "Action"
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
