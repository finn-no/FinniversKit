//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ObjectPagePriceViewModel {
    public let mainPriceModel: Price?
    public let secondaryPriceModel: Price?
    public let links: [PriceLinkButtonViewModel]
    public let priceDetails: [KeyValuePair]
    public let priceDetailsNumberOfColumns: Int
    public let adTypeText: String?
    public let captionText: NSAttributedString?

    public init(
        title: String? = nil,
        totalPrice: String? = nil,
        subtitle: String? = nil,
        accessibilityLabel: String? = nil,
        links: [PriceLinkButtonViewModel] = [],
        priceDetails: [KeyValuePair] = [],
        priceDetailsNumberOfColumns: Int = 2,
        adTypeText: String? = nil,
        captionText: NSAttributedString? = nil
    ) {
        var mainPriceModel: Price?
        if let totalPrice = totalPrice {
            mainPriceModel = Price(title: title, totalPrice: totalPrice, subtitle: subtitle, accessibilityLabel: accessibilityLabel)
        }
        self.init(mainPriceModel: mainPriceModel, links: links, priceDetails: priceDetails, priceDetailsNumberOfColumns: priceDetailsNumberOfColumns, adTypeText: adTypeText, captionText: captionText)
    }

    public init(
        mainPriceModel: Price?,
        secondaryPriceModel: Price? = nil,
        links: [PriceLinkButtonViewModel],
        priceDetails: [KeyValuePair] = [],
        priceDetailsNumberOfColumns: Int = 2,
        adTypeText: String? = nil,
        captionText: NSAttributedString? = nil
    ) {
        self.mainPriceModel = mainPriceModel
        self.secondaryPriceModel = secondaryPriceModel
        self.links = links
        self.priceDetails = priceDetails
        self.priceDetailsNumberOfColumns = priceDetailsNumberOfColumns
        self.adTypeText = adTypeText
        self.captionText = captionText
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
