//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public struct CoronaHelpViewModel {
    public struct Link {
        public let title: String
        public let url: URL?

        public init(title: String, url: URL? = nil) {
            self.title = title
            self.url = url
        }
    }

    public let header: UIImage?
    public let title: String
    public let description: String
    public let readMore: Link
    public let callToAction: Link

    public init(header: UIImage? = nil, title: String, description: String, readMore: Link, callToAction: Link) {
        self.header = header
        self.title = title
        self.description = description
        self.readMore = readMore
        self.callToAction = callToAction
    }
}
