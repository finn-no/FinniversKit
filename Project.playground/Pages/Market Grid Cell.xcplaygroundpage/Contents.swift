import UIKit
import PlaygroundSupport
import Troika

struct MarketGridDataModel: MarketGridPresentable {
    let image: UIImage?
    let title: String
}


let image = #imageLiteral(resourceName: "eiendom.png")
let marketGridCell = MarketGridCell(frame: .zero)
let presentable = MarketGridDataModel(image: image, title: "Eiendom")

let multiplier = image.size.height / image.size.width
let width: CGFloat = 100.0

marketGridCell.presentable = presentable
marketGridCell.frame = CGRect(x: 0, y: 0, width: width, height: (width * multiplier) + MarketGridCell.nonImageHeight)
marketGridCell.backgroundColor = .white

PlaygroundPage.current.liveView = marketGridCell

