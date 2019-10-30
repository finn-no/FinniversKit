//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import Foundation

struct AdConfirmationViewDefaultData: AdConfirmationViewModel {
    var objectViewModel: AdConfirmationObjectViewModel = AdConfirmationObjectViewModelDefaultData()
    var summaryViewModel: AdConfirmationSummaryViewModel? = AdConfirmationSummaryViewModelDefaultData()
    var feedbackViewModel: AdConfirmationFeedbackViewModel?
    var completeActionLabel = "Gå til mine annonser"
}

struct AdConfirmationObjectViewModelDefaultData: AdConfirmationObjectViewModel {
    var imageUrl: URL? = URL(string: "https://www.finn.no")
    var title: String = "title"
    var body: String? = "body"
}

struct AdConfirmationSummaryViewModelDefaultData: AdConfirmationSummaryViewModel {
    var title: String? = "title"
    var orderLines: [String] = ["orderLines"]
    var priceLabel: String = "priceLabel"
    var priceText: String? = "priceText"
    var priceValue: Int = 0
}
