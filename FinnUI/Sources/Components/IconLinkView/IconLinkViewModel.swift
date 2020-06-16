//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct IconLinkViewModel {
    public let icon: UIImage
    public let title: String
    public let url: String

    public init(icon: UIImage, title: String, url: String) {
        self.icon = icon
        self.title = title
        self.url = url
    }
}
