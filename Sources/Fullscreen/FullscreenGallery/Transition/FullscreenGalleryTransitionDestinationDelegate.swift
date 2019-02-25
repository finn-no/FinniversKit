//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

/// Delegate responsible for providing the fullscreen gallery transition with the destination view that the
/// transition will scale into and out of. The delegate is used when transitioning both in and out.
public protocol FullscreenGalleryTransitionDestinationDelegate: class {
    func viewForFullscreenGalleryTransition() -> UIView
    func prepareForTransition(presenting: Bool)
    func performTransitionAnimation(presenting: Bool)
}
