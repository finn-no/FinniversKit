//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

struct PaymentOptionsDemoCellViewModel: PaymentOptionsListViewModel {
    public var title: String
    public var subtitle: String
    public var detailText: String?
}

struct PaymentOptionsListDemoViewHelpers {
    struct OrderSummaryLineModel: OrderSummaryLineViewModel {
        var title: String
        var price: String
    }

    static var items: [PaymentOptionsDemoCellViewModel] = [
        PaymentOptionsDemoCellViewModel(title: "Vipps", subtitle: "Vipps-appen på din mobil"),
        PaymentOptionsDemoCellViewModel(title: "Betalingskort", subtitle: "VISA eller Mastercard"),
        PaymentOptionsDemoCellViewModel(title: "SMS-betaling", subtitle: "På din mobilregning - inkl. operatørkostnader", detailText: "+XX kr"),
        PaymentOptionsDemoCellViewModel(title: "Faktura", subtitle: "Faktura tilsendt"),
    ]

    static var vippsOrderLines: [OrderSummaryLineModel] = [
        OrderSummaryLineModel(title: "Fus", price: "149 kr"),
        OrderSummaryLineModel(title: "Bump-a-Bump", price: "79 kr")
    ]

    static var paymentCardOrderLines: [OrderSummaryLineModel] = [
        OrderSummaryLineModel(title: "Bil til salgs - Plusspakke", price: "849 kr"),
        OrderSummaryLineModel(title: "Blink motor", price: "299 kr"),
        OrderSummaryLineModel(title: "Bump-a-Bump", price: "79 kr")
    ]

    static var smsOrderLines: [OrderSummaryLineModel] = [
        OrderSummaryLineModel(title: "Bil til salgs - Plusspakke", price: "849 kr"),
    ]

    static var invoiceOrderLines: [OrderSummaryLineModel] = [
        OrderSummaryLineModel(title: "Bil til salgs - Plusspakke", price: "849 kr"),
        OrderSummaryLineModel(title: "Bil til salgs - Plusspakke", price: "849 kr"),
        OrderSummaryLineModel(title: "Bil til salgs - Plusspakke", price: "849 kr"),
        OrderSummaryLineModel(title: "Blink motor", price: "299 kr"),
        OrderSummaryLineModel(title: "Fus", price: "149 kr"),
        OrderSummaryLineModel(title: "Bump-a-Bump", price: "79 kr")
    ]
}
