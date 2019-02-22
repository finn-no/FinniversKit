//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol FullscreenGalleryTransitionDestinationDelegate: class {
    func viewForFullscreenGalleryTransitionAsDestination() -> UIView
    func prepareForTransitionAsDestination()
    func performTransitionAnimationAsDestination()
}
