//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FeedbackViewModel {
    let title: String
    let positiveButtonTitle: String?
    let negativeButtonTitle: String?

    public init(title: String, positiveButtonTitle: String? = nil, negativeButtonTitle: String? = nil) {
        self.title = title
        self.positiveButtonTitle = positiveButtonTitle
        self.negativeButtonTitle = negativeButtonTitle
    }
}
