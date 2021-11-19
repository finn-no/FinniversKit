//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct LinkButtonViewModel {
    public let buttonIdentifier: String?
    public let buttonTitle: String
    public let subtitle: String?
    public let linkUrl: URL
    public let isExternal: Bool
    public let buttonStyle: Button.Style?
    public let buttonSize: Button.Size

    public init(
        buttonIdentifier: String?,
        buttonTitle: String,
        subtitle: String? = nil,
        linkUrl: URL,
        isExternal: Bool,
        buttonStyle: Button.Style? = nil,
        buttonSize: Button.Size = .small
    ) {
        self.buttonIdentifier = buttonIdentifier
        self.buttonTitle = buttonTitle
        self.subtitle = subtitle
        self.linkUrl = linkUrl
        self.isExternal = isExternal
        self.buttonStyle = buttonStyle
        self.buttonSize = buttonSize
    }
}
