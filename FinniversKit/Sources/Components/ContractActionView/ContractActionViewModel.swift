//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ContractActionViewModel {
    public let identifier: String?
    public let title: String?
    public let subtitle: String?
    public let buttonTitle: String
    public let buttonUrl: URL

    public init(
        identifier: String?,
        title: String? = nil,
        subtitle: String? = nil,
        buttonTitle: String,
        buttonUrl: URL
    ) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonUrl = buttonUrl
    }
}
