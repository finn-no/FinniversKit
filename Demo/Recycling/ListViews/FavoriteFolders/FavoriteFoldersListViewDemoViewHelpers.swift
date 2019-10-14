//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

struct FavoriteFolder: FavoriteFolderViewModel {
    let id: Int
    let title: String
    let subtitle: String?
    let imagePath: String?
    let isDefault: Bool
    let detailText: String? = "23 annonser"
    let cornerRadius: CGFloat = 12
    let imageViewWidth: CGFloat = 40
    let hasChevron = false
    var isSelected: Bool
}

struct FavoriteFoldersFactory {
    static func create(withSelectedItems: Bool = true) -> [FavoriteFolder] {
        var favorites = [FavoriteFolder]()

        for (index, (title, imagePath)) in zip(titles, imagePaths).enumerated() {
            let isSelected = withSelectedItems ? [0, 1].contains(index) : false
            let folder = FavoriteFolder(
                id: index,
                title: title,
                subtitle: index == 2 ? "Delt liste" : nil,
                imagePath: imagePath,
                isDefault: index == 0,
                isSelected: isSelected
            )

            favorites.append(folder)
        }

        return favorites
    }

    private static var titles: [String] {
        return [
            "Mine funn",
            "We accept up to 50 characters for a folder's name",
            "Mansion",
            "Villa Medusa",
            "Villa Villekulla",
            "Privat slott",
            "Pent brukt bolig",
            "Enebolig i rolig strøk",
            "Hus til slags",
            "Villa Villekulla 2",
            "Privat slott 2",
            "Pent brukt bolig 2",
            "Enebolig i rolig strøk 2",
        ]
    }

    private static var imagePaths: [String?] {
        return [
            "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
            "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg",
            "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg",
            "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
            "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg",
            "https://i.pinimg.com/736x/38/f2/02/38f2028c5956cd6b33bfd16441a05961--victorian-homes-stone-victorian-house.jpg",
            "https://www.younghouselove.com/wp-content/uploads//2017/04/Beach-House-Update-Three-Houses-One-Pink.jpg",
            nil,
            "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
            "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg",
            "https://i.pinimg.com/736x/38/f2/02/38f2028c5956cd6b33bfd16441a05961--victorian-homes-stone-victorian-house.jpg",
            "https://www.younghouselove.com/wp-content/uploads//2017/04/Beach-House-Update-Three-Houses-One-Pink.jpg",
            "https://www.younghouselove.com/wp-content/uploads//2017/04/Beach-House-Update-Three-Houses-One-Pink.jpg"
        ]
    }
}
