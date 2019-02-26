//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol FullscreenGalleryImageSource: class {
    func image(forUrlString urlString: String, width: CGFloat, completionHandler handler: @escaping (String, UIImage?, Error?) -> Void)
}
