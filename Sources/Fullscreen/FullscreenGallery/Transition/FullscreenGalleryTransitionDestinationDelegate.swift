//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol FullscreenGalleryTransitionDestinationDelegate: class {
    func viewForFullscreenGalleryTransition() -> UIView
    func prepareForTransition(presenting: Bool)
    func performTransitionAnimation(presenting: Bool)
}
