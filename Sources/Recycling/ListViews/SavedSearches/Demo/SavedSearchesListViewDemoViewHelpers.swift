//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SavedSearch: SavedSearchesListViewModel {
    public let title: String
    public let subtitle: String?

    public var accessibilityLabel: String {
        return title
    }

    public var settingsButtonAccessibilityLabel: String {
        return title
    }
}

public struct SavedSearchFactory {
    public static func create(numberOfModels: Int) -> [SavedSearch] {
        return (0 ..< numberOfModels).map { index in
            let title = titles[index]
            var subtitle: String?
            if index < subtitles.count {
                 subtitle = subtitles[index]
            }
            return SavedSearch(title: title, subtitle: subtitle)
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

    private static var subtitles: [String] {
        return [
            "Appvarsling på",
            "Appvarsling på, E-postvarsling",
            "Appvarsling på",
            "E-postvarsling"
        ]
    }
}
