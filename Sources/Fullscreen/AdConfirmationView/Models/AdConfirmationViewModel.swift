//
//  Copyright © 2019 FINN AS. All rights reserved.
//

protocol AdConfirmationViewModel: AnyObject {
    var imageUrl: URL? { get set }
    var title: String { get set }
    var body: String? { get set }
    var summary: AdConfirmationSummaryModel? { get set }
    var completeActionLabel: String { get set }
    var feedback: AdConfirmationFeedbackModel? { get set }
}

protocol AdConfirmationSummaryModel: AnyObject {
    var title: String? { get set }
    var orderLines: [String] { get set }
    var priceLabel: String { get set }
    var priceValue: Int { get set }
    var priceText: String? { get set }
}

protocol AdConfirmationFeedbackModel: AnyObject {
    var title: String { get set }
    var url: URL { get set }
    var ratingParameterKey: String { get set }
}
