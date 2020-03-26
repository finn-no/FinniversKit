//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public struct TransactionProcessSummaryViewModel {
    public let title: String
    public let detail: String
    public let description: String

    public init(title: String, detail: String, description: String) {
        self.title = title
        self.detail = detail
        self.description = description
    }
}
