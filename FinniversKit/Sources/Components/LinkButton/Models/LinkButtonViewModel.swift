//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct LinkButtonViewModel {
    let buttonIdentifier: String?
    let buttonTitle: String
    let subtitle: String?
    let linkUrl: URL
    let isExternal: Bool
    let buttonStyle: Button.Style?
    let buttonSize: Button.Size

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
