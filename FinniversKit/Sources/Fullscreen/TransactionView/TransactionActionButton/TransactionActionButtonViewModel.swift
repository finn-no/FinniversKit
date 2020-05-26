//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public struct TransactionActionButtonViewModel {
    public let text: String
    public let style: String?
    public let action: String?
    public let url: String?
    public let fallbackUrl: String?

    public init(text: String, style: String? = nil, action: String? = nil, url: String? = nil, fallbackUrl: String? = nil) {
        self.text = text
        self.style = style
        self.action = action
        self.url = url
        self.fallbackUrl = fallbackUrl
    }
}
