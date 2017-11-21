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

let emailTextField = TextField(inputType: .email)
emailTextField.translatesAutoresizingMaskIntoConstraints = false
emailTextField.placeholderText = "E-post"

let passwordTextField = TextField(inputType: .password)
passwordTextField.translatesAutoresizingMaskIntoConstraints = false
passwordTextField.placeholderText = "Passord"

view.addSubview(emailTextField)
view.addSubview(passwordTextField)

emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: .mediumLargeSpacing).isActive = true
emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .mediumLargeSpacing).isActive = true
emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.mediumLargeSpacing).isActive = true

passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .mediumLargeSpacing).isActive = true
passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .mediumLargeSpacing).isActive = true
passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.mediumLargeSpacing).isActive = true

PlaygroundPage.current.liveView = view
