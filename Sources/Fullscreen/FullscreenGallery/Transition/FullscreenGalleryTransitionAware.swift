//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FullscreenGalleryTransitionAware: AnyObject {
    func prepareForTransition(presenting: Bool)
    func performTransitionAnimation(presenting: Bool)
}
