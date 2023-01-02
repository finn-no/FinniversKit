import Foundation
import FinniversKit

class SavedSearchShelfFactory {
    static func create(numberOfItems items: Int) -> [SavedSearchShelfViewModel] {
        let minCount = min(imageUrls.count, titles.count)
        return (0..<items).map { index in
            let dataIndex = index % minCount
            let title = titles[dataIndex]
            let imageUrl = imageUrls[dataIndex]
            return SavedSearchShelfViewModel(id: Int.random(in: 0...100_000), title: title, imageUrlString: imageUrl, isRead: index > 2)
        }
    }

    private static var titles: [String] {
        return [
            "Elektronikk",
            "Biler",
            "Hus",
            "Båt",
            "Sykler",
            "Torget",
            "Møbler i nabolaget",
            "Håndvekere",
            "Campingvogner"
        ]
    }

    private static var imageUrls: [String] {
        return [
            "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
            "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
            "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
            "https://static.schibsted.com/wp-content/uploads/2018/05/11085129/Schibsted_Logotype_L1_Dust-black_RGB-300x54.png",
            "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg",
            "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg",
            "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
            "http://www.discoverydreamhomes.com/wp-content/uploads/Model-Features-Copper-House.jpg",
            "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg",
            "https://i.pinimg.com/736x/38/f2/02/38f2028c5956cd6b33bfd16441a05961--victorian-homes-stone-victorian-house.jpg",
            "https://www.younghouselove.com/wp-content/uploads//2017/04/Beach-House-Update-Three-Houses-One-Pink.jpg"
        ]
    }
}
