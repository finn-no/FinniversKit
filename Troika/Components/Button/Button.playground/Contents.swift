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

let normalButton = Button(style: .default)
let flatButton = Button(style: .flat)
let destructiveButton = Button(style: .destructive)
let linkButton = Button(style: .link)

let button1 = Button(style: .flat)
let button2 = Button(style: .default)

let disabledNormalButton = Button(style: .default)
let disabledFlatButton = Button(style: .flat)
let disabledDestructiveButton = Button(style: .destructive)
let disabledLinkButton = Button(style: .link)

normalButton.setTitle("Default button", for: .normal)
flatButton.setTitle("Flat button", for: .normal)
destructiveButton.setTitle("Destructive button", for: .normal)
linkButton.setTitle("Link button", for: .normal)

button1.setTitle("Left button", for: .normal)
button2.setTitle("Right button", for: .normal)

disabledNormalButton.setTitle("Disabled default button", for: .normal)
disabledFlatButton.setTitle("Disabled flat button", for: .normal)
disabledDestructiveButton.setTitle("Disabled destructive button", for: .normal)
disabledLinkButton.setTitle("Disabled link button", for: .normal)

disabledNormalButton.isEnabled = false
disabledFlatButton.isEnabled = false
disabledDestructiveButton.isEnabled = false
disabledLinkButton.isEnabled = false

normalButton.translatesAutoresizingMaskIntoConstraints = false
flatButton.translatesAutoresizingMaskIntoConstraints = false
destructiveButton.translatesAutoresizingMaskIntoConstraints = false
linkButton.translatesAutoresizingMaskIntoConstraints = false

button1.translatesAutoresizingMaskIntoConstraints = false
button2.translatesAutoresizingMaskIntoConstraints = false

disabledNormalButton.translatesAutoresizingMaskIntoConstraints = false
disabledFlatButton.translatesAutoresizingMaskIntoConstraints = false
disabledDestructiveButton.translatesAutoresizingMaskIntoConstraints = false
disabledLinkButton.translatesAutoresizingMaskIntoConstraints = false

view.addSubview(normalButton)
view.addSubview(flatButton)
view.addSubview(destructiveButton)
view.addSubview(linkButton)

view.addSubview(button1)
view.addSubview(button2)

view.addSubview(disabledNormalButton)
view.addSubview(disabledFlatButton)
view.addSubview(disabledDestructiveButton)
view.addSubview(disabledLinkButton)

NSLayoutConstraint.activate([
    normalButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .largeSpacing),
    normalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    normalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

    flatButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: .largeSpacing),
    flatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    flatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

    destructiveButton.topAnchor.constraint(equalTo: flatButton.bottomAnchor, constant: .largeSpacing),
    destructiveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    destructiveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

    linkButton.topAnchor.constraint(equalTo: destructiveButton.bottomAnchor, constant: .largeSpacing),
    linkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    linkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

    button1.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: .largeSpacing),
    button1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    button1.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - .largeSpacing - .mediumSpacing),

    button2.topAnchor.constraint(equalTo: button1.topAnchor),
    button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
    button2.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - .largeSpacing - .mediumSpacing),

    disabledNormalButton.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: .largeSpacing),
    disabledNormalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    disabledNormalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

    disabledFlatButton.topAnchor.constraint(equalTo: disabledNormalButton.bottomAnchor, constant: .mediumLargeSpacing),
    disabledFlatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    disabledFlatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

    disabledDestructiveButton.topAnchor.constraint(equalTo: disabledFlatButton.bottomAnchor, constant: .mediumLargeSpacing),
    disabledDestructiveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    disabledDestructiveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),

    disabledLinkButton.topAnchor.constraint(equalTo: disabledDestructiveButton.bottomAnchor, constant: .mediumLargeSpacing),
    disabledLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
    disabledLinkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
])

PlaygroundPage.current.liveView = view
