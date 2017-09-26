import UIKit
import PlaygroundSupport
import Troika

struct GridDataModel: GridPresentable {
    let image: UIImage?
    let title: String
    let subTitle: String
    let imageText: String
}


let image = #imageLiteral(resourceName: "car.jpg")
let gridCell = GridCell(frame: .zero)
let presentable = GridDataModel(image: image, title: "title", subTitle: "subTitle", imageText: "imageText")

let multiplier = image.size.height / image.size.width
let width: CGFloat = 500.0

gridCell.presentable = presentable
gridCell.frame = CGRect(x: 0, y: 0, width: width, height: (width * multiplier) + GridCell.nonImageHeight)
gridCell.backgroundColor = .red

PlaygroundPage.current.liveView = gridCell
