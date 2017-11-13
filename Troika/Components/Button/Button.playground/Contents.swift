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

let normalButton = Button()
let flatButton = Button()
let destructiveButton = Button()

normalButton.presentable = ButtonDataModel.normal
flatButton.presentable = ButtonDataModel.flat
destructiveButton.presentable = ButtonDataModel.destructive

normalButton.translatesAutoresizingMaskIntoConstraints = false
flatButton.translatesAutoresizingMaskIntoConstraints = false
destructiveButton.translatesAutoresizingMaskIntoConstraints = false

view.addSubview(normalButton)
view.addSubview(flatButton)
view.addSubview(destructiveButton)

NSLayoutConstraint.activate([
    normalButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .largeSpacing),
    normalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    normalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
    normalButton.heightAnchor.constraint(equalToConstant: 50),
])

NSLayoutConstraint.activate([
    flatButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: .largeSpacing),
    flatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    flatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
    flatButton.heightAnchor.constraint(equalToConstant: 50),
])

NSLayoutConstraint.activate([
    destructiveButton.topAnchor.constraint(equalTo: flatButton.bottomAnchor, constant: .largeSpacing),
    destructiveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    destructiveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
    destructiveButton.heightAnchor.constraint(equalToConstant: 50),
])

PlaygroundPage.current.liveView = view
