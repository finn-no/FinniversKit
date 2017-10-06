import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

var presentables = Market.allMarkets
let collectionView = MarketGridView(frame: .zero)

collectionView.marketGridPresentables = presentables
collectionView.frame = ScreenSize.medium
collectionView.backgroundColor = .white

PlaygroundPage.current.liveView = collectionView
