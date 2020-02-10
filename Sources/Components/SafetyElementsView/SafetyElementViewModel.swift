//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public struct SafetyElementViewModel {
    let title: String
    let icon: UIImage
    let body: String
    let externalLink: LinkButtonViewModel?

    public init(title: String, icon: UIImage, body: String, externalLink: LinkButtonViewModel?) {
        self.title = title
        self.icon = icon
        self.body = body
        self.externalLink = externalLink
    }
}
