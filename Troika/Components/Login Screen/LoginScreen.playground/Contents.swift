//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let view = UIView()
view.backgroundColor = .white
view.frame = ScreenSize.medium

let loginScreen = LoginScreen()
loginScreen.model = LoginScreenData()

view.addSubview(loginScreen)

loginScreen.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
loginScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
loginScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
loginScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

PlaygroundPage.current.liveView = view
