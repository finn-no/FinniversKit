//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ObjectPagePriceViewModel {
    let title: String
    let totalPrice: String
    let links: [LinkButtonViewModel]

    public init(title: String, totalPrice: String, links: [LinkButtonViewModel]) {
        self.title = title
        self.totalPrice = totalPrice
        self.links = links
    }
}
