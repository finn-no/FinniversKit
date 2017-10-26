//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let marketGridCell = MarketGridCell(frame: .zero)
let presentable = Market.moteplassen

let height: CGFloat = 60.0
let width: CGFloat = 83.0

marketGridCell.presentable = presentable
marketGridCell.frame = CGRect(x: 0, y: 0, width: width, height: height)
marketGridCell.backgroundColor = .white

PlaygroundPage.current.liveView = marketGridCell
