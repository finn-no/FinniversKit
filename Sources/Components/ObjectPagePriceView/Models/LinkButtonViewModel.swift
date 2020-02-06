//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct LinkButtonViewModel {
    let buttonTitle: String
    let subtitle: String?
    let linkUrl: URL

    public init(buttonTitle: String, subtitle: String? = nil, linkUrl: URL) {
        self.buttonTitle = buttonTitle
        self.subtitle = subtitle
        self.linkUrl = linkUrl
    }
}
