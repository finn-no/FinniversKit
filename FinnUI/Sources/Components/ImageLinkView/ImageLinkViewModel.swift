//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ImageLinkViewModel {
    public let description: String
    public let image: UIImage
    public let overlayKind: ImageLinkView.OverlayKind?

    public init(description: String, image: UIImage, overlayKind: ImageLinkView.OverlayKind? = nil) {
        self.description = description
        self.image = image
        self.overlayKind = overlayKind
    }
}
