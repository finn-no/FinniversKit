import Foundation

public enum PlaygroundImage: String {
    case bil
    case bT
    case eiendom
    case jobb
    case mc
    case mittAnbud
    case moteplassen
    case nytte
    case reise
    case shopping
    case smajobb
    case torget
    case webview

    public var image: UIImage {
        return UIImage(named: self.rawValue, in: .troikaPlaygroundSupport, compatibleWith: nil)!
    }
}
