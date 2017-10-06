import UIKit
import PlaygroundSupport
import Troika
import TroikaPlaygroundSupport

TroikaPlaygroundSupport.setupPlayground()

struct ScreenSize {
    static let iPhone5 = CGSize(width: 320, height: 568)
    static let iPhone7 = CGSize(width: 375, height: 667)
    static let iPhone7plus = CGSize(width: 414, height: 736)
    static let iPad = CGSize(width: 768, height: 1024)
}

var presentables = Market.allMarkets
let collectionView = MarketGridView(frame: .zero)
let screenSize = ScreenSize.iPad

collectionView.marketGridPresentables = presentables
collectionView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
collectionView.backgroundColor = .white

PlaygroundPage.current.liveView = collectionView
