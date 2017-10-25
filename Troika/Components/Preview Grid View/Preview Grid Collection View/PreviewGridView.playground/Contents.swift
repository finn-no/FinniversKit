//
//  Copyright © 2017 FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let delegateDataSource = PreviewGridDelegateDataSource()
let view = PreviewGridView(frame: .zero, delegate: delegateDataSource, dataSource: delegateDataSource)

view.frame = ScreenSize.medium
view.previewPresentables = PreviewDataModelFactory.create(numberOfModels: 9)

PlaygroundPage.current.liveView = view
