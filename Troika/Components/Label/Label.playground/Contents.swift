//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let topSpacing: CGFloat = 32
let margin: CGFloat = 16
let interimSpacing: CGFloat = 0

let view = UIView()
let labelT1 = Label(style: .t1)
let labelT2 = Label(style: .t2)
let labelT3 = Label(style: .t3)
let labelT4 = Label(style: .t4(.licorice))
let labelT5 = Label(style: .t5(.licorice))
let labelBody = Label(style: .body(.licorice))
let labelDetail = Label(style: .detail(.licorice))

let testStyle: Label.Style = .body(.licorice)
let multilineLabel = Label(style: testStyle)
let label1 = Label(style: testStyle)
let label2 = Label(style: testStyle)
let label3 = Label(style: testStyle)
let labelWide = Label(style: .body(.licorice))

labelT1.translatesAutoresizingMaskIntoConstraints = false
labelT2.translatesAutoresizingMaskIntoConstraints = false
labelT3.translatesAutoresizingMaskIntoConstraints = false
labelT4.translatesAutoresizingMaskIntoConstraints = false
labelT5.translatesAutoresizingMaskIntoConstraints = false
labelBody.translatesAutoresizingMaskIntoConstraints = false
labelDetail.translatesAutoresizingMaskIntoConstraints = false

multilineLabel.translatesAutoresizingMaskIntoConstraints = false
multilineLabel.numberOfLines = 0
label1.translatesAutoresizingMaskIntoConstraints = false
label2.translatesAutoresizingMaskIntoConstraints = false
label3.translatesAutoresizingMaskIntoConstraints = false
labelWide.translatesAutoresizingMaskIntoConstraints = false
labelWide.backgroundColor = .mint
labelWide.textAlignment = .center

view.backgroundColor = .white
view.frame = ScreenSize.medium

view.addSubview(labelT1)
view.addSubview(labelT2)
view.addSubview(labelT3)
view.addSubview(labelT4)
view.addSubview(labelT5)
view.addSubview(labelBody)
view.addSubview(labelDetail)

view.addSubview(multilineLabel)
view.addSubview(label1)
view.addSubview(label2)
view.addSubview(label3)
view.addSubview(labelWide)

labelT1.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpacing).isActive = true
labelT1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true

labelT2.topAnchor.constraint(equalTo: labelT1.bottomAnchor, constant: interimSpacing).isActive = true
labelT2.leadingAnchor.constraint(equalTo: labelT1.leadingAnchor).isActive = true

labelT3.topAnchor.constraint(equalTo: labelT2.bottomAnchor, constant: interimSpacing).isActive = true
labelT3.leadingAnchor.constraint(equalTo: labelT2.leadingAnchor).isActive = true

labelT4.topAnchor.constraint(equalTo: labelT3.bottomAnchor, constant: interimSpacing).isActive = true
labelT4.leadingAnchor.constraint(equalTo: labelT3.leadingAnchor).isActive = true

labelT5.topAnchor.constraint(equalTo: labelT4.bottomAnchor, constant: interimSpacing).isActive = true
labelT5.leadingAnchor.constraint(equalTo: labelT4.leadingAnchor).isActive = true

labelBody.topAnchor.constraint(equalTo: labelT5.bottomAnchor, constant: interimSpacing).isActive = true
labelBody.leadingAnchor.constraint(equalTo: labelT5.leadingAnchor).isActive = true

labelDetail.topAnchor.constraint(equalTo: labelBody.bottomAnchor, constant: interimSpacing).isActive = true
labelDetail.leadingAnchor.constraint(equalTo: labelBody.leadingAnchor).isActive = true

label1.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: topSpacing).isActive = true
label1.leadingAnchor.constraint(equalTo: labelDetail.leadingAnchor).isActive = true

label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0).isActive = true
label2.leadingAnchor.constraint(equalTo: label1.leadingAnchor).isActive = true

label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 0).isActive = true
label3.leadingAnchor.constraint(equalTo: label2.leadingAnchor).isActive = true

multilineLabel.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 4).isActive = true
multilineLabel.topAnchor.constraint(equalTo: label1.topAnchor).isActive = true
multilineLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true // used to force a linebreak

labelWide.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 16).isActive = true
labelWide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
labelWide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
labelWide.heightAnchor.constraint(equalToConstant: 40).isActive = true

label1.text = "Test"
label2.text = "Test"
label3.text = "Test"
multilineLabel.text = "Test Test Test"
labelWide.text = "Test center"

labelT1.text = "Label T1"
labelT2.text = "Label T2"
labelT3.text = "Label T3"
labelT4.text = "Label T4"
labelT5.text = "Label T5"
labelBody.text = "Label Body"
labelDetail.text = "Label Detail"

PlaygroundPage.current.liveView = view
