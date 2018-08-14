//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// A model confirming to the FavoritesListViewModel protocol for showcasing FavoritesListViewCell in playground.
public struct Favorite: FavoritesListViewModel {
    public var imagePath: String?
    public var imageSize: CGSize
    public var detail: String
    public var title: String

    public var accessibilityLabel: String {
        var message = detail
        message += ". " + title
        return message
    }
}

/// Creates Favorites
public struct FavoriteFactory {
    private struct ImageSource {
        let path: String
        let size: CGSize
    }

    public static func create() -> [Favorite] {
        var favorites = [Favorite]()
        for favoriteIndex in 0 ... 3 {
            let imageSource = imageSources[favoriteIndex]
            let detail = details[favoriteIndex]
            let title = titles[favoriteIndex]
            favorites.append(Favorite(imagePath: imageSource.path, imageSize: imageSource.size, detail: detail, title: title))
        }

        return favorites
    }

    private static var details: [String] {
        return [
            "Aktiv - 1200,-",
            "Avvist",
            "Slettet",
            "Frist utløpt",
            "Frist utløpt - Solgt"
        ]
    }

    private static var titles: [String] {
        return [
            "Findings Festival 2018 - Helgepass",
            "Superfin Flodhest",
            "Annonsen er slettet",
            "Canon 5d mark iii",
            "Leveringsklar dvergpinscher-valp"
        ]
    }

    private static var imageSources: [ImageSource] {
        return [
            ImageSource(path: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg", size: CGSize(width: 450, height: 354)),
            ImageSource(path: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg", size: CGSize(width: 800, height: 600)),
            ImageSource(path: "http://jonvilma.com/images/house-6.jpg", size: CGSize(width: 992, height: 546)),
            ImageSource(path: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg", size: CGSize(width: 736, height: 566)),
            ImageSource(path: "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg", size: CGSize(width: 550, height: 734))
        ]
    }
}
