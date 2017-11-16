//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

var models = Market.allMarkets
let collectionView = MarketGridView(frame: .zero)

collectionView.marketGridModels = models
collectionView.frame = ScreenSize.medium
collectionView.backgroundColor = .white

PlaygroundPage.current.liveView = collectionView
