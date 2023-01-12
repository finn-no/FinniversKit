import Foundation
import FinniversKit

class RecentlyFavoritedFactory {
    static func create(numberOfItems items: Int) -> [RecentlyFavoritedViewmodel] {
        let ads = AdFactory.create(numberOfModels: items)

        return ads.map {
            RecentlyFavoritedViewmodel(
                id: Int.random(in: 1...100_000),
                imageUrl: $0.imagePath,
                location: "Oslo",
                title: $0.title,
                created: UUID().uuidString,
                price: $0.imageText)
        }
    }
}
