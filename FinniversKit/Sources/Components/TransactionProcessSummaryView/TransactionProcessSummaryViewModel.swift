//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public struct TransactionProcessSummaryViewModel {
    public let title: String
    public let detail: String
    public let description: String
    public let externalTitle: String?
    public let style: String?

    public init(title: String, detail: String, description: String, externalTitle: String?, style: String?) {
        self.title = title
        self.detail = detail
        self.description = description
        self.externalTitle = externalTitle
        self.style = style
    }
}
