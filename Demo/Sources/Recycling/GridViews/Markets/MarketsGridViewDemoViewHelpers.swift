//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public enum Market: MarketsViewModel {
    case eiendom
    case bil
    case torget
    case jobb
    case mc
    case boat
    case nytte
    case reise
    case shopping
    case economy
    case moteplassen
    case mittAnbud

    case eiendomNew
    case bilOgNaering
    case torgetNew
    case jobbNew
    case mcNew
    case boatNew
    case reiseNew
    case economyNew
    case moteplassenNew
    case mittAnbudNew
    case leiebilNew
    case nettbilNew

    //ADDED MORE WORDS TO TEST
    public var title: String {
        switch self {
        case .eiendom, .eiendomNew: return "Eiendom"
        case .bil: return "Bil"
        case .torget, .torgetNew: return "Torget"
        case .jobb, .jobbNew: return "Nya andra Jobb och arbeten"
        case .mc, .mcNew: return "MC"
        case .boat, .boatNew: return "Båtar och segelbåtar"
        case .nytte: return "Nyttekjøretøy"
        case .reise, .reiseNew: return "Reise"
        case .shopping: return "Shopping"
        case .economy, .economyNew: return "Økonomi o pengar"
        case .moteplassen, .moteplassenNew: return "Møteplassen o test line"
        case .mittAnbud: return "Oppdrag"
        case .mittAnbudNew: return "Mitt anbud och ditt"
        case .leiebilNew: return "Leiebil"
        case .nettbilNew: return "Nettbil"
        case .bilOgNaering: return "Bil og næring"
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
        case .economy: return UIImage(named: .okonomi)
        case .moteplassen: return UIImage(named: .moteplassen)
        case .mittAnbud: return UIImage(named: .mittanbud)

        case .eiendomNew: return UIImage(named: .realestateNew)
        case .bilOgNaering: return UIImage(named: .carNew)
        case .torgetNew: return UIImage(named: .classifiedsNew)
        case .jobbNew: return UIImage(named: .jobsNew)
        case .mcNew: return UIImage(named: .mcNew)
        case .boatNew: return UIImage(named: .boatNew)
        case .reiseNew: return UIImage(named: .travelNew)
        case .economyNew: return UIImage(named: .okonomiNew)
        case .moteplassenNew: return UIImage(named: .moteplassenNew)
        case .mittAnbudNew: return UIImage(named: .mittanbudNew)
        case .leiebilNew: return UIImage(named: .leiebilNew)
        case .nettbilNew: return UIImage(named: .nettbilNew)
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
        case .economy: return true
        case .moteplassen: return true
        case .mittAnbud: return true

        case .eiendomNew: return false
        case .bilOgNaering: return false
        case .torgetNew: return false
        case .jobbNew: return false
        case .mcNew: return false
        case .boatNew: return false
        case .reiseNew: return true
        case .economyNew: return true
        case .moteplassenNew: return true
        case .mittAnbudNew: return true
        case .leiebilNew: return true
        case .nettbilNew: return true
        }
    }

    public var accessibilityLabel: String {
        if showExternalLinkIcon {
            return title + ". Merk: Åpner ekstern link"
        } else {
            return title
        }
    }

    public static var allMarkets: [Market] = [.eiendom, .bil, .torget, .jobb, .mc, .boat, .nytte, .economy, .reise, .mittAnbud, .shopping, .moteplassen]
    public static var newMarkets: [Market] = [
        .eiendomNew,
        .bilOgNaering,
        .torgetNew,
        .jobbNew,
        .reiseNew,
        .mcNew,
        .boatNew,
        .economyNew,
        .leiebilNew,
        .nettbilNew,
        .moteplassenNew,
        .mittAnbudNew
    ]
}
