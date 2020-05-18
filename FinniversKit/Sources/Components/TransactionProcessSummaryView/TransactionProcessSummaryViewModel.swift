//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public struct TransactionProcessSummaryViewModel {
    public let title: String
    public let detail: String
    public let description: String
    public let externalView: TransactionActionButtonViewModel?
    public let style: String?

    public init(title: String, detail: String, description: String, externalView: TransactionActionButtonViewModel?, style: String?) {
        self.title = title
        self.detail = detail
        self.description = description
        self.externalView = externalView
        self.style = style
    }
}
