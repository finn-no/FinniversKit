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
let imageView = UIImageView()
imageView.image = UIImage(named: "bil")

let textField = UITextField()
textField.translatesAutoresizingMaskIntoConstraints = false
textField.backgroundColor = .ice
textField.placeholder = "Password"
textField.rightView?.addSubview(imageView)
textField.borderStyle = .roundedRect
textField.isSecureTextEntry = true

view.addSubview(textField)

textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
//textField.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true

PlaygroundPage.current.liveView = view
