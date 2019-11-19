//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import Foundation

struct AdConfirmationViewDefaultData: AdConfirmationViewModel {
    var objectViewModel: AdConfirmationObjectViewModel = AdConfirmationObjectViewModelDefaultData()
    var summaryViewModel: AdConfirmationSummaryViewModel? = AdConfirmationSummaryViewModelDefaultData()
    var feedbackViewModel: AdConfirmationFeedbackViewModel?
    var completeButtonText = "Gå til mine annonser"
}

struct AdConfirmationObjectViewModelDefaultData: AdConfirmationObjectViewModel {
    var imageUrl: URL? = URL(string: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg")
    var title: String = "Ekstra synlighet i boks!"
    var body: String? = "Om ett til to minutter er annonsen synlig på FINN"
}

struct AdConfirmationSummaryViewModelDefaultData: AdConfirmationSummaryViewModel {
    var title: String? = "Ditt kjøp"
    var orderLines: [String] = ["Torget annonse", "Bil annonse", "Bolig til leie", "Blink", "Oppsalgsprodukt", "Bolig til leie", "Blink", "Oppsalgsprodukt", "Bolig til leie", "Blink", "Oppsalgsprodukt", "Bolig til leie", "Blink", "Oppsalgsprodukt", "Bolig til leie", "Blink", "Oppsalgsprodukt", "Bolig til leie"]
    var priceLabel: String = "Totalsum"
    var priceValue: String = "100000"
    var receiptInfo: String?
}
