//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol AdConfirmationFeedbackViewModel {
    var title: String { get set }
    var url: URL { get set }
    var ratingParameterKey: String { get set }
}
