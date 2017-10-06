import UIKit
import PlaygroundSupport
import Troika
import TroikaPlaygroundSupport

TroikaPlaygroundSupport.setupPlayground()

struct ScreenSize {
    static let iPhone5 = CGSize(width: 320, height: 568)
    static let iPhone7 = CGSize(width: 375, height: 667)
    static let iPhone7plus = CGSize(width: 414, height: 736)
    static let iPad = CGSize(width: 768, height: 1024)
}

let screenSize = ScreenSize.iPhone7

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
view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)

successRibbonView.presentable = RibbonDataModel.success
errorRibbonView.presentable = RibbonDataModel.error
warningRibbonView.presentable = RibbonDataModel.warning
defaultRibbonView.presentable = RibbonDataModel.ordinary
disabledRibbonView.presentable = RibbonDataModel.disabled
sponsoredRibbonView.presentable = RibbonDataModel.sponsored

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
