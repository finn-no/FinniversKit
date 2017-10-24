import Foundation
import Troika

public enum Market: MarketGridPresentable {
    case eiendom
    case bil
    case torget
    case jobb
    case mc
    case bT
    case nytte
    case reise
    case shopping
    case smajobb
    case moteplassen
    case mittAnbud

    public var title: String {
        switch self {
        case .eiendom: return "Eiendom"
        case .bil: return "Bil"
        case .torget: return "Torget"
        case .jobb: return "Jobb"
        case .mc: return "MC"
        case .bT: return "Båt"
        case .nytte: return "Nyttekjøretøy"
        case .reise: return "Reise"
        case .shopping: return "Shopping"
        case .smajobb: return "Småjobber"
        case .moteplassen: return "Møteplassen"
        case .mittAnbud: return "Oppdrag"
        }
    }

    public var iconImage: UIImage? {
        switch self {
        case .eiendom: return UIImage(named: "eiendom", in: .troikaDemoKit, compatibleWith: nil)
        case .bil: return UIImage(named: "bil", in: .troikaDemoKit, compatibleWith: nil)
        case .torget: return UIImage(named: "torget", in: .troikaDemoKit, compatibleWith: nil)
        case .jobb: return UIImage(named: "jobb", in: .troikaDemoKit, compatibleWith: nil)
        case .mc: return UIImage(named: "mc", in: .troikaDemoKit, compatibleWith: nil)
        case .bT: return UIImage(named: "bT", in: .troikaDemoKit, compatibleWith: nil)
        case .nytte: return UIImage(named: "nytte", in: .troikaDemoKit, compatibleWith: nil)
        case .reise: return UIImage(named: "reise", in: .troikaDemoKit, compatibleWith: nil)
        case .shopping: return UIImage(named: "shopping", in: .troikaDemoKit, compatibleWith: nil)
        case .smajobb: return UIImage(named: "smajobb", in: .troikaDemoKit, compatibleWith: nil)
        case .moteplassen: return UIImage(named: "moteplassen", in: .troikaDemoKit, compatibleWith: nil)
        case .mittAnbud: return UIImage(named: "mittAnbud", in: .troikaDemoKit, compatibleWith: nil)
        }
    }

    public var showExternalLinkIcon: Bool {
        switch self {
        case .eiendom: return false
        case .bil: return false
        case .torget: return false
        case .jobb: return false
        case .mc: return false
        case .bT: return false
        case .nytte: return false
        case .reise: return true
        case .shopping: return true
        case .smajobb: return true
        case .moteplassen: return true
        case .mittAnbud: return true
        }
    }

    public var accessibilityLabel: String {
        if showExternalLinkIcon {
            return title + ". Merk: Åpner ekstern link"
        } else {
            return title
        }
    }

    public static var allMarkets: [Market] = [.eiendom, .bil, .torget, .jobb, .mc, .bT, .nytte, .reise, .shopping, .smajobb, .moteplassen, .mittAnbud]
}
