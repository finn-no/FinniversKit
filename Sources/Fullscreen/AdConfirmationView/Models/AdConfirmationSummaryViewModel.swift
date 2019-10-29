//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol AdConfirmationSummaryViewModel {
    var title: String? { get set }
    var orderLines: [String] { get set }
    var priceLabel: String { get set }
    var priceText: String? { get set }
    var priceValue: Int { get set }
}
