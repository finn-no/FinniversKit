//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

extension SwitchViewDefaultModel {
    static var demoViewModel1 = SwitchViewDefaultModel(
        title: "Anbefalinger",
        detail: "Vi gir deg relevante tips på forsiden",
        initialSwitchValue: true
    )

    static var demoViewModel2 = SwitchViewDefaultModel(
        title: "Smart reklame",
        detail: "Vi leter for deg når du gjør andre ting",
        initialSwitchValue: false
    )

    static var demoViewModel3 = SwitchViewDefaultModel(
        title: "Annen styling",
        detail: "Denne her har en annen styling enn de to andre over",
        initialSwitchValue: true
    )
}
