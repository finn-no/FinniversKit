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

let images: [UIImage] = [#imageLiteral(resourceName: "eiendom.png"), #imageLiteral(resourceName: "bil.png"), #imageLiteral(resourceName: "torget.png"), #imageLiteral(resourceName: "jobb.png"), #imageLiteral(resourceName: "mc.png"), #imageLiteral(resourceName: "bT.png"), #imageLiteral(resourceName: "nytte.png"), #imageLiteral(resourceName: "smajobb.png"), #imageLiteral(resourceName: "reise.png"), #imageLiteral(resourceName: "mittAnbud.png"), #imageLiteral(resourceName: "shopping.png"), #imageLiteral(resourceName: "moteplassen.png")]
let titles: [String] = ["Eiendom","Bil", "Torget", "Jobb", "MC", "Båt", "Nyttekjøretøy", "Småjobber", "Reise", "Oppdrag", "Shopping", "Møteplassen"]
let shouldShowExternal: [Bool] = [false, false, false, false, false, false, false, true, true, true, true, true]

let eiendom = MarketGridDataModel(iconImage: image, showExternalLinkIcon: shouldShowExternalLinkIcon, title: title)

var presentables = [MarketGridDataModel]()
let collectionView = MarketGridCollectionView(frame: .zero)
let screenSize = ScreenSize.iPad

for index in 0...titles.count-1 {
    
    presentables.append(MarketGridDataModel(iconImage: images[index], showExternalLinkIcon: shouldShowExternal[index], title: titles[index]))
}

collectionView.marketGridPresentables = presentables
collectionView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
collectionView.backgroundColor = .white

PlaygroundPage.current.liveView = collectionView
