//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct LoginEntryDemoData: LoginEntryViewModel {
    let title: String
    let detail: String
    let includeSettings: Bool
    let loginButtonTitle: String = "Logg inn"
    let registerButtonTitle: String = "Opprett en konto"

    init(title: String, detail: String, includeSettings: Bool = false) {
        self.title = title
        self.detail = detail
        self.includeSettings = includeSettings
    }
}

extension LoginEntryDemoData {
    enum Page {
        case notifications
        case ads
        case messages
        case settings

        var asset: FinniversImageAsset {
            switch self {
            case .notifications: return .notifications
            case .ads: return .yourads
            case .messages: return .messages
            case .settings: return .profile
            }
        }

        var data: LoginEntryDemoData {
            switch self {
            case .notifications:
                return LoginEntryDemoData(
                    title: "Få et pling når\ndet skjer noe",
                    detail: "Logg inn for å få varsling om nye treff på lagrede søk og når det kommer prisendringer på dine favoritter."
                )
            case .ads:
                return LoginEntryDemoData(
                    title: "Selg eller gi bort\ndet du ikke trenger",
                    detail: "Legg ut en annonse på FINN for å selge, gi bort eller leie ut (nesten) hva som helst."
                )
            case .messages:
                return LoginEntryDemoData(
                    title: "Få kontakt med\nselgere og kjøpere",
                    detail: "Spør selgeren om det du lurer på, og få spørsmål fra dine potensielle kjøpere."
                )
            case .settings:
                return LoginEntryDemoData(
                    title: "Mulighetenes\nmarked",
                    detail: "Logg inn for å kjøpe, selge eller drømme deg bort i biler, hus eller tingene på torget.",
                    includeSettings: true
                )
            }
        }
    }
}
