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

struct RibbonDataModel: RibbonPresentable {
    let type: RibbonType
    let title: String
}

let screenSize = ScreenSize.iPhone7
let ribbonView = RibbonView(frame: .init(x: 10, y: 10, width: 130, height: 20))
let view = UIView(frame: .zero)
let ribbonText = "Denne er solgt!"
let presentable = RibbonDataModel(type: RibbonType.error, title: ribbonText)

view.backgroundColor = .white
view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)

ribbonView.presentable = presentable
ribbonView.frame

view.addSubview(ribbonView)
view.bringSubview(toFront: ribbonView)

PlaygroundPage.current.liveView = view
