//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol OrderSummaryLineViewModel {
    var title: String { get set }
    var price: String { get set }
}

public protocol OrderSummaryViewModel {
    var orderLines: [OrderSummaryLineViewModel] { get set }
}
