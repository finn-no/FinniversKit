//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct FavoriteFolder: FavoriteFoldersListViewModel {
    public var title: String
    public var detail: String

    public var accessibilityLabel: String {
        var message = title
        message += ". " + detail
        return message
    }
}

public struct FavoriteFoldersFactory {
    public static func create() -> [FavoriteFolder] {
        var favorites = [FavoriteFolder]()
        for favoriteIndex in 0 ... 3 {
            let title = titles[favoriteIndex]
            let detail = details[favoriteIndex]
            favorites.append(FavoriteFolder(title: title, detail: detail))
        }

        return favorites
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
            "Hus til slags"
        ]
    }

    private static var details: [String] {
        return [
            "3 annonser",
            "1 annonse",
            "Ingen annonser",
            "3 annonser",
            "1 annonse",
            "Ingen annonser"
        ]
    }
}
