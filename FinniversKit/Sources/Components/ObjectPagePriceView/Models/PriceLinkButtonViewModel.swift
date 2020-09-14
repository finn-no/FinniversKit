//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public enum PriceLinkButtonKind: String {
    case regular
    case variantCompact = "variant-compact"
    case variantFull = "variant-full"
}

public struct PriceLinkButtonViewModel {
    let buttonIdentifier: String?
    let buttonTitle: String
    let subtitle: String?
    let heading: String?
    let subheading: String?
    let linkUrl: URL
    let isExternal: Bool
    let kind: PriceLinkButtonKind

    public init(
        buttonIdentifier: String?,
        buttonTitle: String,
        subtitle: String? = nil,
        heading: String? = nil,
        subheading: String? = nil,
        linkUrl: URL,
        isExternal: Bool,
        kind: PriceLinkButtonKind = .regular
    ) {
        self.buttonIdentifier = buttonIdentifier
        self.buttonTitle = buttonTitle
        self.subtitle = subtitle
        self.heading = heading
        self.subheading = subheading
        self.linkUrl = linkUrl
        self.isExternal = isExternal
        self.kind = kind
    }
}
