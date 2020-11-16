//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct ProjectUnitViewModel {
    let imageUrl: String?
    let topDetailText: String?
    let title: String?
    let price: String?
    let area: String?
    let bottomDetailText: String?

    public init(
        imageUrl: String?,
        topDetailText: String?,
        title: String?,
        price: String?,
        area: String?,
        bottomDetailText: String?
    ) {
        self.imageUrl = imageUrl
        self.topDetailText = topDetailText
        self.title = title
        self.price = price
        self.area = area
        self.bottomDetailText = bottomDetailText
    }
}
