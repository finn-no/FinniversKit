//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ObjectPagePriceViewModel {
    let mainPriceModel: Price
    let secondaryPriceModel: Price?
    let links: [LinkButtonViewModel]

    public init(title: String, totalPrice: String, subtitle: String? = nil, links: [LinkButtonViewModel]) {
        let mainPriceModel = Price(title: title, totalPrice: totalPrice, subtitle: subtitle)
        self.init(mainPriceModel: mainPriceModel, links: links)
    }

    public init(mainPriceModel: Price, secondaryPriceModel: Price? = nil, links: [LinkButtonViewModel]) {
        self.mainPriceModel = mainPriceModel
        self.secondaryPriceModel = secondaryPriceModel
        self.links = links
    }

    public struct Price {
        let title: String
        let totalPrice: String
        let subtitle: String?

        public init(title: String, totalPrice: String, subtitle: String? = nil) {
            self.title = title
            self.totalPrice = totalPrice
            self.subtitle = subtitle
        }
    }
}
