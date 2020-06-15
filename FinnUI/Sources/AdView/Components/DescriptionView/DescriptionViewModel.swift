//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import Foundation

public struct DescriptionViewModel {
    let content: String
    let expandButtonTitle: String
    let collapseButtonTitle: String

    public init(
        content: String,
        expandButtonTitle: String,
        collapseButtonTitle: String
    ) {
        self.content = content
        self.expandButtonTitle = expandButtonTitle
        self.collapseButtonTitle = collapseButtonTitle
    }
}

// Sample data destined for previews
extension DescriptionViewModel {
    static let sampleData = DescriptionViewModel(
        content: "Veil kr 10 999,- (kjøpt som ny i 2019) - Treningsmatte + iPad holder til sykkelen medfølger.\r\n\r\nVi selger spinningsykkelen vores da vi ikke får brukt den som ønsket (har hatt ca.15-20 treningsøkter på sykkelen). Sykkelen har stått inne siden vi kjøpte den i 2019.\r\n\r\nPrisen reflektere at sykkelen har bruk for en ny sensor på hjulet (ødelagt av barn) for at måle tråkk pr minutt, tid, hastighet og puls: https://www.solefitnessparts.com/Speed-Sensor-SOLRP0918.htm\r\n\r\nBeskrivelse: Youtube: https://www.youtube.com/watch?v=rENf8lAsFzg\r\n\r\nSpinningsykkel som dekker behovet, både for landeveissykkelisten og terrengsykkelisten.\r\n\r\nSpinningsykkel med mulighet for meget høy motstand. Kraftig krank som tåler tunge tråkk. Svinghul på 22 kg, samt bremse system med kevlar, gjør spinningsykkelen perfekt til raske intervaller eller styrketråkk. Reimdrift gjør spinningsykkelen meget stillegående.\r\n\r\nEnkel og solid trinnløs justering av sete og styret, gjør det enkelt å justere om det er mange som skal bruke den i et trimrom.\r\n\r\nTrådløs computer følger med. Computeren viser cadence (tråkk pr minutt), tid, hastighet og puls. Trådløs mottaker av puls. (Pulsbelte medfølger ikke)\r\n\r\nProduktspesifikasjoner:\r\nSvinghul: 22kg\r\nPedaler: pedaler med tåhette\r\nJustering sete/styre: trinnløs\r\nDrivverk: reimdrift\r\nTransporthjul: ja\r\nFlaskeholder: 2 stk\r\nFlasker: 1 stk\r\n\r\nComputer: trådløs med bakgrunnsbelyst 65 mm x 50 mm LCD display\r\n- cacence (antall tråkk pr. minutt), tid, hastighet og puls\r\nPulsmottaker: trådløs (pulsbelte medfølger ikke)\r\n\r\nVekt: 64 kg\r\nMaks brukervekt: 136 kg\r\nStørrelse: 109 cm x 54 cm x 95 cm",
        expandButtonTitle: "- Vis mindre",
        collapseButtonTitle: "+ Vis mer"
    )
}
