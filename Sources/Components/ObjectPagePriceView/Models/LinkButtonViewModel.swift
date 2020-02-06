//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct LinkButtonViewModel {
    let buttonIdentifier: String?
    let buttonTitle: String
    let subtitle: String?
    let linkUrl: URL

    public init(buttonIdentifier: String?, buttonTitle: String, subtitle: String? = nil, linkUrl: URL) {
        self.buttonIdentifier = buttonIdentifier
        self.buttonTitle = buttonTitle
        self.subtitle = subtitle
        self.linkUrl = linkUrl
    }
}
