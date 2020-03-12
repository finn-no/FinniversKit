//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ObjectPagePriceViewModel {
    let title: String
    let totalPrice: String
    let subtitle: String?
    let links: [LinkButtonViewModel]

    public init(title: String, totalPrice: String, subtitle: String? = nil, links: [LinkButtonViewModel]) {
        self.title = title
        self.totalPrice = totalPrice
        self.subtitle = subtitle
        self.links = links
    }
}
