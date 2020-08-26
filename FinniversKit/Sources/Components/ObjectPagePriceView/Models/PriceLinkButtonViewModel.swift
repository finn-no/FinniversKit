//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct PriceLinkButtonViewModel {
    let buttonIdentifier: String?
    let buttonTitle: String
    let subtitle: String?
    let heading: String?
    let subheading: String?
    let linkUrl: URL
    let isExternal: Bool

    public init(
        buttonIdentifier: String?,
        buttonTitle: String,
        subtitle: String? = nil,
        heading: String? = nil,
        subheading: String? = nil,
        linkUrl: URL,
        isExternal: Bool
    ) {
        self.buttonIdentifier = buttonIdentifier
        self.buttonTitle = buttonTitle
        self.subtitle = subtitle
        self.heading = heading
        self.subheading = subheading
        self.linkUrl = linkUrl
        self.isExternal = isExternal
    }
}
