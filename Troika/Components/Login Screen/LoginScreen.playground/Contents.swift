//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let loginScreen = LoginScreen(frame: ScreenSize.medium)
loginScreen.model = LoginScreenData()
loginScreen.backgroundColor = .milk

PlaygroundPage.current.liveView = loginScreen
