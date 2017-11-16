//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

class MarketData: NSObject {
    var models = Market.allMarkets
}

extension MarketData: MarketGridViewDataSource {
    func numberOfItems(inMarketGridView marketGridView: MarketGridView) -> Int {
        return models.count
    }

    func marketGridView(_ marketGridView: MarketGridView, modelAtIndex index: Int) ->  MarketGridModel {
        return models[index]
    }
}

extension MarketData: MarketGridViewDelegate {
    func didSelect(itemAtIndex index: Int, inMarketGridView gridView: MarketGridView) {

    }
}

TroikaDemoKit.setupPlayground()

let data = MarketData()
let collectionView = MarketGridView(delegate: data, dataSource: data)
collectionView.frame = ScreenSize.medium
collectionView.backgroundColor = .white

PlaygroundPage.current.liveView = collectionView

