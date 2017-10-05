import UIKit
import PlaygroundSupport
import Troika
import TroikaPlaygroundSupport

TroikaPlaygroundSupport.setupPlayground()

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
