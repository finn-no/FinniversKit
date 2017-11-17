//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let previewCell = PreviewCell(frame: .zero)
let model = PreviewDataModelFactory.create(numberOfModels: 1).first!
let dataSource = APreviewCellDataSource()

let multiplier = model.imageSize.height / model.imageSize.width
let width: CGFloat = 200.0

previewCell.loadingColor = .blue
previewCell.dataSource = dataSource
previewCell.model = model
previewCell.frame = CGRect(x: 0, y: 0, width: width, height: (width * multiplier) + PreviewCell.nonImageHeight)

PlaygroundPage.current.liveView = previewCell
