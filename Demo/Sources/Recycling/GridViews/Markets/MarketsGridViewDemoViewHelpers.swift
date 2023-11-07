//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public enum ToriMarket: MarketsViewModel {
    case furniture
    case clothing // vaatteita, kosmetiikkaa ja asusteita
    case  parents // vanhemmat ja lapset
    case sports // urheilu ja ulkoilu
    case animals // eläimet ja laitteet
    case leisure // harrastus ja viihde
    case apartments // asuntoja vuokralle
    case remppatori
    case vehicles // ajoneuvojen
    case electronics // elektroniikka ja kodinkoneet
    case garden// puutarha, remontti ja talo
    case vehicleparts// ajoneuvojen osia
    case jobs // työpaikkoja
    case antiquities // antiikkia ja taidetta
    case autovex
    
    public var title: String {
        switch self {
        case .furniture: return "Huonekalutjasisustus"
        case .clothing: return "Vaatteita, kosmetiikkaa ja asusteita"
        case .parents: return "Vanhemmat ja lapset"
        case .sports: return "Urheilu ja ulkoilu"
        case .animals: return "eläimet ja laitteet"
        case .leisure: return "harrastus ja viihde"
        case .apartments: return "asuntoja vuokralle"
        case .remppatori: return "remppatori"
        case .vehicles: return "ajoneuvojen"
        case .electronics: return "elektroniikka ja kodinkoneet"
        case .garden: return "puutarha, remontti ja talo"
        case .vehicleparts: return "ajoneuvojen osia"
        case .jobs: return "työpaikat"
        case .antiquities: return "antiikkia ja taidetta"
        case .autovex: return "Autovex"
        }
    }
    
    public var iconImage: UIImage? {
        switch self {
        case .furniture: return UIImage(named: .furniture)
        case .clothing: return UIImage(named: .clothing)
        case .parents: return UIImage(named: .parentskids)
        case .sports: return UIImage(named: .sports)
        case .animals: return UIImage(named: .animals)
        case .leisure: return UIImage(named: .hobbies)
        case .apartments: return UIImage(named: .iconRealestateApartments)
        case .remppatori: return UIImage(named: .remppatori)
        case .vehicles: return UIImage(named: .vehicles)
        case .electronics: return UIImage(named: .electronics)
        case .garden: return UIImage(named: .renovation)
        case .vehicleparts: return UIImage(named: .car)
        case .jobs: return UIImage(named: .oikotie)
        case .antiquities: return UIImage(named: .antiques)
        case .autovex: return UIImage(named: .autovex)
        }
    }
    
    public var showExternalLinkIcon: Bool {
        switch self {
        case .furniture: return false
        case .clothing: return false
        case .parents: return false
        case .sports: return false
        case .animals: return false
        case .leisure: return false
        case .apartments: return false
        case .remppatori: return true
        case .vehicles: return true
        case .electronics: return true
        case .garden: return true
        case .vehicleparts: return true
        case .jobs: return false
        case .antiquities: return false
        case .autovex: return false
        }
    }
    public static var toriMarkets: [ToriMarket] = [
        .furniture,
        .clothing,
        .parents,
        .sports,
        .animals,
        .leisure,
        .apartments,
        .remppatori,
        .vehicles,
        .electronics,
        .garden,
        .jobs,
        .antiquities,
        .autovex
    ]
}

public enum FinnMarket: MarketsViewModel {
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
    case mittAnbud

    case eiendomNew
    case bilOgNaering
    case torgetNew
    case jobbNew
    case mcNew
    case boatNew
    case reiseNew
    case economyNew
    case mittAnbudNew
    case leiebilNew
    case nettbilNew
    
    public var title: String {
        switch self {
        case .eiendom, .eiendomNew: return "Eiendom"
        case .bil: return "Bil"
        case .torget, .torgetNew: return "Torget"
        case .jobb, .jobbNew: return "Jobb"
        case .mc, .mcNew: return "MC"
        case .boat, .boatNew: return "Båt"
        case .nytte: return "Nyttekjøretøy"
        case .reise, .reiseNew: return "Reise"
        case .shopping: return "Shopping"
        case .economy, .economyNew: return "Økonomi"
        case .mittAnbud: return "Oppdrag"
        case .mittAnbudNew: return "Mitt anbud"
        case .leiebilNew: return "Leiebil"
        case .nettbilNew: return "Nettbil"
        case .bilOgNaering: return "Bil og næring"
        }
    }

    public var iconImage: UIImage? {
        switch self {
        case .eiendom: return UIImage(named: .iconRealestateApartments)
        case .bil: return UIImage(named: .car)
        case .torget: return UIImage(named: .remppatori)
        case .jobb: return UIImage(named: .oikotie)
        case .mc: return UIImage(named: .motorcycle)
        case .boat: return UIImage(named: .sailboat)
        case .nytte: return UIImage(named: .vehicles)
        case .reise: return UIImage(named: .airplane)
        case .shopping: return UIImage(named: .oikotie)
        case .economy: return UIImage(named: .economy)
        case .mittAnbud: return UIImage(named: .mittanbud)

        case .eiendomNew: return UIImage(named: .iconRealestateApartments)
        case .bilOgNaering: return UIImage(named: .car)
        case .torgetNew: return UIImage(named: .market)
        case .jobbNew: return UIImage(named: .oikotie)
        case .mcNew: return UIImage(named: .motorcycle)
        case .boatNew: return UIImage(named: .sailboat)
        case .reiseNew: return UIImage(named: .airplane)
        case .economyNew: return UIImage(named: .economy)
        case .mittAnbudNew: return UIImage(named: .mittanbud)
        case .leiebilNew: return UIImage(named: .rentalcar)
        case .nettbilNew: return UIImage(named: .nettbil)
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
        case .mittAnbud: return true

        case .eiendomNew: return false
        case .bilOgNaering: return false
        case .torgetNew: return false
        case .jobbNew: return false
        case .mcNew: return false
        case .boatNew: return false
        case .reiseNew: return true
        case .economyNew: return true
        case .mittAnbudNew: return true
        case .leiebilNew: return true
        case .nettbilNew: return true
        }
    }

    /*
    public static var allMarkets: [FinnMarket] = [
        .eiendom,
        .bil,
        .torget,
        .jobb,
        .mc,
        .boat,
        .nytte,
        .economy,
        .reise,
        .mittAnbud,
        .shopping
    ]*/
    
    public static var newMarkets: [FinnMarket] = [
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
        .mittAnbudNew
    ]
}
