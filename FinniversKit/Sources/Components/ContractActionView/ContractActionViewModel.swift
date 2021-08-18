//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ContractActionViewModel {
    public let title: String?
    public let subtitle: String?
    public let identifier: String?
    public let strings: [String]
    public let buttonTitle: String
    public let buttonUrl: URL

    public init(
        title: String? = nil,
        subtitle: String? = nil,
        identifier: String?,
        strings: [String],
        buttonTitle: String,
        buttonUrl: URL
    ) {
        self.title = title
        self.subtitle = subtitle
        self.identifier = identifier
        self.strings = strings
        self.buttonTitle = buttonTitle
        self.buttonUrl = buttonUrl
    }
}
