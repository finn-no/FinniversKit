import Foundation
import Troika

/// A model confirming to the PreviewPresentable protocol for showcasing PreviewCell in playground.
public struct PreviewDataModel: PreviewPresentable {
    public let imageUrl: URL?
    public let imageSize: CGSize
    public let iconImage: UIImage
    public let title: String
    public let subTitle: String
    public let imageText: String
    public var accessibilityLabel: String {
        if imageText.isEmpty {
            return title + ". " + subTitle
        } else {
            return title + ". " + subTitle + ". Pris: kroner " + imageText
        }
    }
}

/// For use with PreviewGridView.
public class PreviewGridDelegateDataSource: NSObject, PreviewGridViewDelegate, PreviewGridViewDataSource {

    public func didSelect(item _: PreviewPresentable, in _: PreviewGridView) {
        // Not in use
    }

    public func loadImage(for url: URL, completion: @escaping ((UIImage?) -> Void)) {
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
}

/// For use with PreviewCell.
public class APreviewCellDataSource: NSObject, PreviewCellDataSource {

    public func loadImage(for url: URL, completion: @escaping ((UIImage?) -> Void)) {
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
}

/// Creates PreviewDataModels
public struct PreviewDataModelFactory {

    private struct ImageSource {
        let url: URL
        let size: CGSize
    }

    public static func create(numberOfModels: Int) -> [PreviewDataModel] {
        return (0 ..< numberOfModels).map { index in
            let imageSource = imageSources[index]
            let title = titles[index]
            let subTitle = subTitles[index]
            let icon = UIImage(named: "bil", in: .troikaDemoKit, compatibleWith: nil)!
            return PreviewDataModel(imageUrl: imageSource.url, imageSize: imageSource.size, iconImage: icon, title: title, subTitle: subTitle, imageText: price)
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
            ImageSource(url: URL(string: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg")!, size: CGSize(width: 450, height: 354)),
            ImageSource(url: URL(string: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg")!, size: CGSize(width: 800, height: 600)),
            ImageSource(url: URL(string: "http://jonvilma.com/images/house-6.jpg")!, size: CGSize(width: 992, height: 546)),
            ImageSource(url: URL(string: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg")!, size: CGSize(width: 736, height: 566)),
            ImageSource(url: URL(string: "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg")!, size: CGSize(width: 550, height: 734)),
            ImageSource(url: URL(string: "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg")!, size: CGSize(width: 1000, height: 672)),
            ImageSource(url: URL(string: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg")!, size: CGSize(width: 1200, height: 800)),
            ImageSource(url: URL(string: "http://www.discoverydreamhomes.com/wp-content/uploads/Model-Features-Copper-House.jpg")!, size: CGSize(width: 1000, height: 563)),
            ImageSource(url: URL(string: "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg")!, size: CGSize(width: 640, height: 799)),
            ImageSource(url: URL(string: "https://i.pinimg.com/736x/38/f2/02/38f2028c5956cd6b33bfd16441a05961--victorian-homes-stone-victorian-house.jpg")!, size: CGSize(width: 523, height: 640)),
            ImageSource(url: URL(string: "https://www.younghouselove.com/wp-content/uploads//2017/04/Beach-House-Update-Three-Houses-One-Pink.jpg")!, size: CGSize(width: 1500, height: 1125)),
        ]
    }
}
