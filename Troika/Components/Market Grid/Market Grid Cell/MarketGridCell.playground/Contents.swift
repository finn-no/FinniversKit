import UIKit
import PlaygroundSupport
import Troika
import TroikaPlaygroundSupport

struct MarketGridDataModel: MarketGridPresentable {
    let iconImage: UIImage?
    let showExternalLinkIcon: Bool
    let title: String
}

TroikaPlaygroundSupport.setupPlayground()

let image = PlaygroundImage.moteplassen.image
let title = "Møteplassen"
let shouldShowExternalLinkIcon = true

let marketGridCell = MarketGridCell(frame: .zero)
let presentable = MarketGridDataModel(iconImage: image, showExternalLinkIcon: shouldShowExternalLinkIcon, title: title)

let height: CGFloat = 60.0
let width: CGFloat = 83.0

marketGridCell.presentable = presentable
marketGridCell.frame = CGRect(x: 0, y: 0, width: width, height: height)
marketGridCell.backgroundColor = .white

PlaygroundPage.current.liveView = marketGridCell
