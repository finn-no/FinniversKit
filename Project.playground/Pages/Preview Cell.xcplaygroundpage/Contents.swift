import UIKit
import PlaygroundSupport
import Troika

struct PreviewDataModel: PreviewPresentable {
    let image: UIImage?
    let iconImage: UIImage?
    let title: String
    let subTitle: String
    let imageText: String
}

let image = #imageLiteral(resourceName: "car.jpg")
let icon = #imageLiteral(resourceName: "bil.png")
let previewCell = PreviewCell(frame: .zero)
let presentable = PreviewDataModel(image: image, iconImage: icon, title: "Rolex Daytone i platina", subTitle: "Steinkjær", imageText: "170 000,-")

let multiplier = image.size.height / image.size.width
let width: CGFloat = 200.0

previewCell.presentable = presentable
previewCell.frame = CGRect(x: 0, y: 0, width: width, height: (width * multiplier) + PreviewCell.nonImageHeight)

PlaygroundPage.current.liveView = previewCell
