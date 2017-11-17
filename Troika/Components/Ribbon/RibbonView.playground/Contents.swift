//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let successRibbonView = RibbonView()
let errorRibbonView = RibbonView()
let warningRibbonView = RibbonView()
let defaultRibbonView = RibbonView()
let disabledRibbonView = RibbonView()
let sponsoredRibbonView = RibbonView()

let interimSpacing: CGFloat = 16
let lineSpacing: CGFloat = 8
let margin: CGFloat = 16
let view = UIView()

view.backgroundColor = .white
view.frame = ScreenSize.medium

successRibbonView.model = RibbonDataModel.success
errorRibbonView.model = RibbonDataModel.error
warningRibbonView.model = RibbonDataModel.warning
defaultRibbonView.model = RibbonDataModel.ordinary
disabledRibbonView.model = RibbonDataModel.disabled
sponsoredRibbonView.model = RibbonDataModel.sponsored

defaultRibbonView.translatesAutoresizingMaskIntoConstraints = false
successRibbonView.translatesAutoresizingMaskIntoConstraints = false
warningRibbonView.translatesAutoresizingMaskIntoConstraints = false
errorRibbonView.translatesAutoresizingMaskIntoConstraints = false
disabledRibbonView.translatesAutoresizingMaskIntoConstraints = false
sponsoredRibbonView.translatesAutoresizingMaskIntoConstraints = false

view.addSubview(headerLabel)
view.addSubview(successRibbonView)
view.addSubview(errorRibbonView)
view.addSubview(warningRibbonView)
view.addSubview(defaultRibbonView)
view.addSubview(disabledRibbonView)
view.addSubview(sponsoredRibbonView)

headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: margin).isActive = true

defaultRibbonView.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor).isActive = true
defaultRibbonView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: margin).isActive = true

successRibbonView.leadingAnchor.constraint(equalTo: defaultRibbonView.trailingAnchor, constant: interimSpacing).isActive = true
successRibbonView.topAnchor.constraint(equalTo: defaultRibbonView.topAnchor).isActive = true

warningRibbonView.leadingAnchor.constraint(equalTo: successRibbonView.trailingAnchor, constant: interimSpacing).isActive = true
warningRibbonView.topAnchor.constraint(equalTo: successRibbonView.topAnchor).isActive = true

errorRibbonView.leadingAnchor.constraint(equalTo: warningRibbonView.trailingAnchor, constant: interimSpacing).isActive = true
errorRibbonView.topAnchor.constraint(equalTo: warningRibbonView.topAnchor).isActive = true

disabledRibbonView.leadingAnchor.constraint(equalTo: defaultRibbonView.leadingAnchor).isActive = true
disabledRibbonView.topAnchor.constraint(equalTo: defaultRibbonView.bottomAnchor, constant: lineSpacing).isActive = true

sponsoredRibbonView.leadingAnchor.constraint(equalTo: disabledRibbonView.trailingAnchor, constant: interimSpacing).isActive = true
sponsoredRibbonView.topAnchor.constraint(equalTo: disabledRibbonView.topAnchor).isActive = true

PlaygroundPage.current.liveView = view
