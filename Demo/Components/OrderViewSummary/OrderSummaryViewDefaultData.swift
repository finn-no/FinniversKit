//
//  Created by Saleh-Jan, Robin on 10/12/2019.
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct OrderSummaryViewDefaultData: OrderSummaryViewModel {
    struct OrderSummaryLineModel: OrderSummaryLineViewModel {
        var title: String
        var price: String
    }

    var orderLines: [OrderSummaryLineViewModel] = [
        OrderSummaryLineModel(title: "Bil til salgs - Plusspakke", price: "849 kr"),
        OrderSummaryLineModel(title: "Blink motor", price: "299 kr"),
        OrderSummaryLineModel(title: "Fus", price: "149 kr"),
        OrderSummaryLineModel(title: "Bump-a-Bump", price: "79 kr")
    ]
}
