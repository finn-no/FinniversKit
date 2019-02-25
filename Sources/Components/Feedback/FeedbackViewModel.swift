//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FeedbackViewModel {
    let title: String
    let message: String?
    let positiveButtonTitle: String?
    let negativeButtonTitle: String?

    public init(title: String, message: String? = nil, positiveButtonTitle: String? = nil, negativeButtonTitle: String? = nil) {
        self.title = title
        self.message = message
        self.positiveButtonTitle = positiveButtonTitle
        self.negativeButtonTitle = negativeButtonTitle
    }
}
