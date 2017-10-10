import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let topSpacing: CGFloat = 32
let marging: CGFloat = 16
let interimSpacing: CGFloat = 8

let view = UIView()
let labelT1 = Label(style: .t1)
let labelT2 = Label(style: .t2)
let labelT3 = Label(style: .t3)
let labelT4 = Label(style: .t4)
let labelBody = Label(style: .body)
let labelDetail = Label(style: .detail)

labelT1.translatesAutoresizingMaskIntoConstraints = false
labelT2.translatesAutoresizingMaskIntoConstraints = false
labelT3.translatesAutoresizingMaskIntoConstraints = false
labelT4.translatesAutoresizingMaskIntoConstraints = false
labelBody.translatesAutoresizingMaskIntoConstraints = false
labelDetail.translatesAutoresizingMaskIntoConstraints = false

view.backgroundColor = .white
view.frame = ScreenSize.medium

view.addSubview(labelT1)
view.addSubview(labelT2)
view.addSubview(labelT3)
view.addSubview(labelT4)
view.addSubview(labelBody)
view.addSubview(labelDetail)

labelT1.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpacing).isActive = true
labelT1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: marging).isActive = true

labelT2.topAnchor.constraint(equalTo: labelT1.bottomAnchor, constant: interimSpacing).isActive = true
labelT2.leadingAnchor.constraint(equalTo: labelT1.leadingAnchor).isActive = true

labelT3.topAnchor.constraint(equalTo: labelT2.bottomAnchor, constant: interimSpacing).isActive = true
labelT3.leadingAnchor.constraint(equalTo: labelT2.leadingAnchor).isActive = true

labelT4.topAnchor.constraint(equalTo: labelT3.bottomAnchor, constant: interimSpacing).isActive = true
labelT4.leadingAnchor.constraint(equalTo: labelT3.leadingAnchor).isActive = true

labelBody.topAnchor.constraint(equalTo: labelT4.bottomAnchor, constant: interimSpacing).isActive = true
labelBody.leadingAnchor.constraint(equalTo: labelT4.leadingAnchor).isActive = true

labelDetail.topAnchor.constraint(equalTo: labelBody.bottomAnchor, constant: interimSpacing).isActive = true
labelDetail.leadingAnchor.constraint(equalTo: labelBody.leadingAnchor).isActive = true

labelT1.text = "Label T1"
labelT2.text = "Label T2"
labelT3.text = "Label T3"
labelT4.text = "Label T4"
labelBody.text = "Label Body"
labelDetail.text = "Label Detail"

PlaygroundPage.current.liveView = view
