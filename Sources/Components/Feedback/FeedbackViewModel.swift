//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FeedbackViewModel {
    public let title: String
    public let positiveButtonTitle: String?
    public let negativeButtonTitle: String?

    public init(title: String, positiveButtonTitle: String? = nil, negativeButtonTitle: String? = nil) {
        self.title = title
        self.positiveButtonTitle = positiveButtonTitle
        self.negativeButtonTitle = negativeButtonTitle
    }
}
