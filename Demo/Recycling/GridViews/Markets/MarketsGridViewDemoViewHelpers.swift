//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public enum Market: MarketsGridViewModel {
    case eiendom
    case bil
    case torget
    case jobb
    case mc
    case boat
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
        case .boat: return "Båt"
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
        case .eiendom: return UIImage(named: .realestate)
        case .bil: return UIImage(named: .car)
        case .torget: return UIImage(named: .classifieds)
        case .jobb: return UIImage(named: .jobs)
        case .mc: return UIImage(named: .mc)
        case .boat: return UIImage(named: .boat)
        case .nytte: return UIImage(named: .vehicles)
        case .reise: return UIImage(named: .travel)
        case .shopping: return UIImage(named: .shopping)
        case .smajobb: return UIImage(named: .smalljobs)
        case .moteplassen: return UIImage(named: .moteplassen)
        case .mittAnbud: return UIImage(named: .mittanbud)
        }
    }

    public var showExternalLinkIcon: Bool {
        switch self {
        case .eiendom: return false
        case .bil: return false
        case .torget: return false
        case .jobb: return false
        case .mc: return false
        case .boat: return false
        case .nytte: return false
        case .reise: return true
        case .shopping: return true
        case .smajobb: return true
        case .moteplassen: return true
        case .mittAnbud: return true
        }
    }

    public var badgeImage: UIImage? {
        switch self {
        case .shopping: return UIImage(named: .onlyNew)
        default: return nil
        }
    }

    public var accessibilityLabel: String {
        if showExternalLinkIcon {
            return title + ". Merk: Åpner ekstern link"
        } else {
            return title
        }
    }

    public static var allMarkets: [Market] = [.eiendom, .bil, .torget, .jobb, .mc, .boat, .nytte, .reise, .shopping, .smajobb, .moteplassen, .mittAnbud]
}
