//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol AdConfirmationViewModel {
    var objectViewModel: AdConfirmationObjectViewModel { get set }
    var summaryViewModel: AdConfirmationSummaryViewModel? { get set }
    var feedbackViewModel: AdConfirmationFeedbackViewModel? { get set }
    var completeActionLabel: String { get set }
}
