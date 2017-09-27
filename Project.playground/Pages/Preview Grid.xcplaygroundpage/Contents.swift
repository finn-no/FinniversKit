import UIKit
import PlaygroundSupport
import Troika

struct PreviewDataModel: PreviewPresentable {
    let image: UIImage?
    let iconImage: UIImage?
    let title: String
    let subTitle: String
    let imageText: String
}

class TheDelegate: NSObject, PreviewGridCollectionViewDelegate {
    func didSelect(item: PreviewPresentable, in gridView: PreviewGridCollectionView) {
        // Placeholder
    }
}

let delegate = TheDelegate()
let view = PreviewGridCollectionView(frame: .zero, delegate: delegate)

view.frame = CGRect(x: 0, y: 0, width: 375, height: 768)

var presentables =  [PreviewDataModel]()

for i in 0..<5 {
    presentables.append(PreviewDataModel(image: #imageLiteral(resourceName: "car.jpg"), iconImage: #imageLiteral(resourceName: "bil.png"), title: "Rolex Daytone i platina", subTitle: "Steinkjær", imageText: "170 000,-"))
}

view.previewPresentables = presentables

PlaygroundPage.current.liveView = view
