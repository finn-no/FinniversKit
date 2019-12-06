//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public class SearchResultListEmptyViewModel {

    let title: String
    let body: String
    let buttonTitle: String?

    public init(title: String, body: String, buttonTitle: String? = nil) {
        self.title = title
        self.body = body
        self.buttonTitle = buttonTitle
    }
}
