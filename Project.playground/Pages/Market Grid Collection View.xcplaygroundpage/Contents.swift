import UIKit
import PlaygroundSupport
import Troika

struct MarketGridDataModel: MarketGridPresentable {
    let iconImage: UIImage?
    let showExternalLinkIcon: Bool
    let title: String
}

struct ScreenSize {
    static let iPhone5 = CGSize(width: 320, height: 568)
    static let iPhone7 = CGSize(width: 375, height: 667)
    static let iPhone7plus = CGSize(width: 414, height: 736)
    static let iPad = CGSize(width: 768, height: 1024)
}

let image = #imageLiteral(resourceName: "eiendom.png")
let title = "Eiendom"
let shouldShowExternalLinkIcon = false
let eiendom = MarketGridDataModel(iconImage: image, showExternalLinkIcon: shouldShowExternalLinkIcon, title: title)

var presentables = [MarketGridDataModel]()
let collectionView = MarketGridCollectionView(frame: .zero)
let screenSize = ScreenSize.iPad

for _ in 1...7 {
    presentables.append(eiendom)
}
for _ in 1...5 {
    presentables.append(MarketGridDataModel(iconImage: image, showExternalLinkIcon: true, title: title))
}

collectionView.marketGridPresentables = presentables
collectionView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
collectionView.backgroundColor = .white

PlaygroundPage.current.liveView = collectionView
