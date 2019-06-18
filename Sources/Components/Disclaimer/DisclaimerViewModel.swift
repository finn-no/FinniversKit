//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct DisclaimerViewModel {
    public let disclaimerText: String
    public let readMoreButtonTitle: String

    public init(disclaimerText: String, readMoreButtonTitle: String) {
        self.disclaimerText = disclaimerText
        self.readMoreButtonTitle = readMoreButtonTitle
    }
}
