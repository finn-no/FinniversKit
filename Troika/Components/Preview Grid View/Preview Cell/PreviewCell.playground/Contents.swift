import UIKit
import PlaygroundSupport
import Troika
import TroikaPlaygroundSupport

struct PreviewDataModel: PreviewPresentable {
    let imageUrl: URL?
    let imageSize: CGSize
    let iconImage: UIImage
    let title: String
    let subTitle: String
    let imageText: String
}

let previewCell = PreviewCell(frame: .zero)
let presentable = PreviewDataModelFactory.create(numberOfModels: 1).first!
let dataSource = APreviewCellDataSource()

let multiplier = presentable.imageSize.height / presentable.imageSize.width
let width: CGFloat = 200.0

previewCell.loadingColor = .blue
previewCell.dataSource = dataSource
previewCell.presentable = presentable
previewCell.frame = CGRect(x: 0, y: 0, width: width, height: (width * multiplier) + PreviewCell.nonImageHeight)

PlaygroundPage.current.liveView = previewCell
