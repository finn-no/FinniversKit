//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public struct TransactionProcessSummaryViewModel {
    public let title: String
    public let detail: String
    public let description: String
    public let externalView: TransactionProcessSummaryExternalViewModel?
    public let style: String?

    public init(title: String, detail: String, description: String, externalView: TransactionProcessSummaryExternalViewModel?, style: String?) {
        self.title = title
        self.detail = detail
        self.description = description
        self.externalView = externalView
        self.style = style
    }
}

// swiftlint:disable:next superfluous_disable_command type_name
public struct TransactionProcessSummaryExternalViewModel {
    public let url: String
    public let text: String

    public init(url: String, text: String) {
        self.url = url
        self.text = text
    }
}
