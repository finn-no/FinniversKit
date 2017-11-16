//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Troika

/// A model confirming to the PreviewModel protocol for showcasing PreviewGridCell in playground.
public struct PreviewDataModel: PreviewModel {
    public let imagePath: String?
    public let imageSize: CGSize
    public var iconImage: UIImage?
    public let title: String
    public let subTitle: String?
    public let imageText: String?

    public var accessibilityLabel: String {
        var message = title

        if let subTitle = subTitle {
            message += ". " + subTitle
        }

        if let imageText = imageText {
            message += ". Pris: kroner " + imageText
        }

        return message
    }
}

/// For use with PreviewGridView.
public class PreviewGridDelegateDataSource: NSObject, PreviewGridViewDelegate, PreviewGridViewDataSource {

    private let models = PreviewDataModelFactory.create(numberOfModels: 9)

    public func willDisplay(itemAtIndex index: Int, inPreviewGridView gridView: PreviewGridView) {
        // Don't care
    }

    public func didScroll(gridScrollView: UIScrollView) {
        // Don't care
    }

    public func didSelect(itemAtIndex index: Int, inPreviewGridView gridView: PreviewGridView) {
        // Not in use
    }

    public func numberOfItems(inPreviewGridView previewGridView: PreviewGridView) -> Int {
        return models.count
    }

    public func previewGridView(_ previewGridView: PreviewGridView, modelAtIndex index: Int) -> PreviewModel {
        return models[index]
    }

    public func loadImage(for model: PreviewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    public func cancelLoadImage(for model: PreviewModel, imageWidth: CGFloat) {
        // No point in doing this in demo
    }
}

/// For use with PreviewGridCell.
public class APreviewGridCellDataSource: NSObject, PreviewGridCellDataSource {

    public func loadImage(for model: PreviewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    public func cancelLoadImage(for model: PreviewModel, imageWidth: CGFloat) {
        // No point in doing this in demo
    }
}

/// Creates PreviewDataModels
public struct PreviewDataModelFactory {

    private struct ImageSource {
        let path: String
        let size: CGSize
    }

    public static func create(numberOfModels: Int) -> [PreviewDataModel] {
        return (0 ..< numberOfModels).map { index in
            let imageSource = imageSources[index]
            let title = titles[index]
            let subTitle = subTitles[index]
            let icon = UIImage(named: "bil", in: .localBundle, compatibleWith: nil)!
            return PreviewDataModel(imagePath: imageSource.path, imageSize: imageSource.size, iconImage: icon, title: title, subTitle: subTitle, imageText: price)
        }
    }

    private static var titles: [String] {
        return [
            "Home Sweet Home",
            "Hjemmekjært",
            "Mansion",
            "Villa Medusa",
            "Villa Villekulla",
            "Privat slott",
            "Pent brukt bolig",
            "Enebolig i rolig strøk",
            "Hus til slags",
        ]
    }

    private static var subTitles: [String] {
        return [
            "Oslo",
            "Bergen",
            "Trondheim",
            "Ved havet",
            "Toten",
            "Nordkapp",
            "Langtvekkistan",
            "Elverum",
            "Brønnøysund",
            "Bodø",
        ]
    }

    private static var price: String {
        let thousands = Int(arc4random_uniform(UInt32(999)))
        return "\(thousands) 000,-"
    }

    private static var randomImageSource: ImageSource {
        let random = Int(arc4random_uniform(UInt32(imageSources.count)))
        return imageSources[random]
    }

    private static var imageSources: [ImageSource] {
        return [
            ImageSource(path: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg", size: CGSize(width: 450, height: 354)),
            ImageSource(path: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg", size: CGSize(width: 800, height: 600)),
            ImageSource(path: "http://jonvilma.com/images/house-6.jpg", size: CGSize(width: 992, height: 546)),
            ImageSource(path: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg", size: CGSize(width: 736, height: 566)),
            ImageSource(path: "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg", size: CGSize(width: 550, height: 734)),
            ImageSource(path: "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg", size: CGSize(width: 1000, height: 672)),
            ImageSource(path: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg", size: CGSize(width: 1200, height: 800)),
            ImageSource(path: "http://www.discoverydreamhomes.com/wp-content/uploads/Model-Features-Copper-House.jpg", size: CGSize(width: 1000, height: 563)),
            ImageSource(path: "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg", size: CGSize(width: 640, height: 799)),
            ImageSource(path: "https://i.pinimg.com/736x/38/f2/02/38f2028c5956cd6b33bfd16441a05961--victorian-homes-stone-victorian-house.jpg", size: CGSize(width: 523, height: 640)),
            ImageSource(path: "https://www.younghouselove.com/wp-content/uploads//2017/04/Beach-House-Update-Three-Houses-One-Pink.jpg", size: CGSize(width: 1500, height: 1125)),
        ]
    }
}
