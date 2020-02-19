//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public struct SafetyElementViewModel {
    public let title: String
    public let icon: UIImage
    public let body: String
    public let topLink: LinkButtonViewModel?
    public let bottomLink: LinkButtonViewModel?

    public init(title: String, icon: UIImage, body: String, topLink: LinkButtonViewModel? = nil, bottomLink: LinkButtonViewModel? = nil) {
        self.title = title
        self.icon = icon
        self.body = body
        self.topLink = topLink
        self.bottomLink = bottomLink
    }
}
