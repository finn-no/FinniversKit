//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct SaveSearchPromptViewModel {
    let title: String
    let positiveButtonTitle: String?

    public init(title: String, positiveButtonTitle: String? = nil) {
        self.title = title
        self.positiveButtonTitle = positiveButtonTitle
    }
}
