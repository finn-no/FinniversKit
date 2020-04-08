//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct OrderSummaryLineModel: OrderSummaryLineViewModel {
    var title: String
    var price: String
}

struct OrderSummaryViewRegularDefaultData {
    static var orderLines: [OrderSummaryLineModel] = [
        OrderSummaryLineModel(title: "Torget annonse", price: "0 kr"),
    ]
}

struct OrderSummaryViewCarDefaultData {
    static var orderLines: [OrderSummaryLineModel] = [
        OrderSummaryLineModel(title: "Bil til salgs - Plusspakke", price: "849 kr"),
        OrderSummaryLineModel(title: "Blink motor", price: "299 kr"),
        OrderSummaryLineModel(title: "Fus", price: "149 kr"),
        OrderSummaryLineModel(title: "Bump-a-Bump", price: "79 kr")
    ]
}
