//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let view = EmptyScreen(frame: ScreenSize.medium)
view.backgroundColor = .white

view.header = "Her var det stille gitt"
view.message = "Når du prater med andre på FINN, vil meldingene dine dukke opp her.\n\n Søk på noe du har lyst på, send en melding til selgeren og bli enige om en handel på én-to-tre!"

PlaygroundPage.current.liveView = view
