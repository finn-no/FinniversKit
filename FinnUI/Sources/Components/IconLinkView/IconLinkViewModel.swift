//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct IconLinkViewModel {
    public let icon: UIImage
    public let title: String
    public let url: String
    public let identifier: String?

    public init(icon: UIImage, title: String, url: String, identifier: String?) {
        self.icon = icon
        self.title = title
        self.url = url
        self.identifier = identifier
    }
}
