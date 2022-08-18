//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ContractActionViewModel {
    public let identifier: String?
    public let title: String?
    public let subtitle: String?
    public let description: String?
    public let strings: [String]?
    public let buttonTitle: String
    public let buttonUrl: URL

    public init(
        identifier: String?,
        title: String? = nil,
        subtitle: String? = nil,
        description: String? = nil,
        strings: [String]? = nil,
        buttonTitle: String,
        buttonUrl: URL
    ) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.strings = strings
        self.buttonTitle = buttonTitle
        self.buttonUrl = buttonUrl
    }
}
