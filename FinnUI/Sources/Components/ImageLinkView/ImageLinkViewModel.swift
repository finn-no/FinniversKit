//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ImageLinkViewModel {
    public let description: String
    public let url: String
    public let imageUrl: String
    public let loadingColor: UIColor?
    public let fallbackImage: UIImage?
    public let overlayKind: ImageLinkView.OverlayKind?

    public init(description: String, url: String, imageUrl: String, loadingColor: UIColor? = nil, fallbackImage: UIImage? = nil, overlayKind: ImageLinkView.OverlayKind? = nil) {
        self.description = description
        self.url = url
        self.imageUrl = imageUrl
        self.loadingColor = loadingColor
        self.fallbackImage = fallbackImage
        self.overlayKind = overlayKind
    }
}
