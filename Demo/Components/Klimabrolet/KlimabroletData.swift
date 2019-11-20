//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import Bootstrap

struct KlimabroletData {
    static let campaignURL = URL(string: "https://klimabrolet.no")

    struct ViewModel: KlimabroletViewModel {
        let title: String = "Bli med og BRØØØL!"
        let subtitle: String = "30 August kl. 15.00"
        let bodyText: String = "Barn og unge over hele verden har samlet seg i gatene til støtte for miljøet. Ikke la dem stå alene. Bli med og brøl for klimaet!"
        let readMoreButtonTitle: String = "Les mer om Klimabrølet"
        let acceptButtonTitle: String = "Bli med på Klimabrølet!"
        let declineButtonTitle: String = "Nei takk"
    }

    struct Event {
        let name: String
        let url: URL? = URL(string: "https://klimabrolet.no/faq")
    }

    static let events: [Event] = [
        Event(name: "Klimabrølet Oslo"),
        Event(name: "Klimabrølet Tønsberg"),
        Event(name: "Klimabrølet Stavanger"),
        Event(name: "Klimabrølet Bergen"),
        Event(name: "Klimabrølet Røros"),
        Event(name: "Klimabrølet Trondheim"),
        Event(name: "Klimabrølet Henningsvær"),
        Event(name: "Klimabrølet Svalbard")
    ]
}

extension KlimabroletData.Event: BasicTableViewCellViewModel {
    var title: String { return name }
    var subtitle: String? { return nil }
    var detailText: String? { return nil }
    var hasChevron: Bool { return false }
}
