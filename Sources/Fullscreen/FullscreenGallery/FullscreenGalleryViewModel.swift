//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FullscreenGalleryViewModel {
    var imageUrls: [String] { get }
    var selectedIndex: Int { get set }
    var imageCaptions: [String] { get }
}
