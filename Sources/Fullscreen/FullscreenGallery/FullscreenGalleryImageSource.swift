//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public enum FullscreenGalleryImageSize {
    case thumbnail
    case fullscreen
}

public protocol FullscreenGalleryImageSource {
    func image(forUrlString urlString: String, size: FullscreenGalleryImageSize, completionHandler handler: @escaping (String, UIImage?, Error?) -> Void)
}
