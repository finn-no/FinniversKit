//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FullscreenGalleryTransitionAware: class {
    func prepareForTransition(presenting: Bool)
    func performTransitionAnimation(presenting: Bool)
}
