//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ObjectPagePriceViewModel {
    let mainPriceModel: Price?
    let secondaryPriceModel: Price?
    let links: [PriceLinkButtonViewModel]
    let priceDetails: [KeyValuePair]
    let adTypeText: String?

    public init(
        title: String? = nil,
        totalPrice: String? = nil,
        subtitle: String? = nil,
        accessibilityLabel: String? = nil,
        links: [PriceLinkButtonViewModel] = [],
        priceDetails: [KeyValuePair] = [],
        adTypeText: String? = nil
    ) {
        var mainPriceModel: Price?
        if let totalPrice = totalPrice {
            mainPriceModel = Price(title: title, totalPrice: totalPrice, subtitle: subtitle, accessibilityLabel: accessibilityLabel)
        }
        self.init(mainPriceModel: mainPriceModel, links: links, priceDetails: priceDetails, adTypeText: adTypeText)
    }

    public init(
        mainPriceModel: Price?,
        secondaryPriceModel: Price? = nil,
        links: [PriceLinkButtonViewModel],
        priceDetails: [KeyValuePair] = [],
        adTypeText: String? = nil
    ) {
        self.mainPriceModel = mainPriceModel
        self.secondaryPriceModel = secondaryPriceModel
        self.links = links
        self.priceDetails = priceDetails
        self.adTypeText = adTypeText
    }

    public struct Price {
        let title: String?
        let totalPrice: String
        let subtitle: String?
        let accessibilityLabel: String?

        public init(title: String?, totalPrice: String, subtitle: String? = nil, accessibilityLabel: String? = nil) {
            self.title = title
            self.totalPrice = totalPrice
            self.subtitle = subtitle
            self.accessibilityLabel = accessibilityLabel
        }
    }
}
