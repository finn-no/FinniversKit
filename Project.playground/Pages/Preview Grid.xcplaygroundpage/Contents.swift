import UIKit
import PlaygroundSupport
import Troika

let delegateDataSource = PreviewGridDelegateDataSource()
let view = PreviewGridView(frame: .zero, delegate: delegateDataSource, dataSource: delegateDataSource)

view.frame = CGRect(x: 0, y: 0, width: 375, height: 768)
view.previewPresentables = PreviewDataModelFactory.create(numberOfModels: 9)

PlaygroundPage.current.liveView = view
