//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

/// Delegate responsible for providing the fullscreen gallery transition with the destination view that the
/// transition will scale into and out of. The delegate is used when transitioning both in and out.
public protocol FullscreenGalleryTransitionDestinationDelegate: class {
    func imageViewForFullscreenGalleryTransition() -> UIImageView?

    /// When the UIImageView returned from imageViewForFullscreenGalleryTransition() has an unset image, this
    /// method will be called. The delegate should display the provided image and return the frame of the image view.
    ///
    /// - Notes:
    ///   The returned frame must be in global coordinates.
    func displayIntermediateImageAndCalculateGlobalFrame(_ image: UIImage) -> CGRect

    func prepareForTransition(presenting: Bool)
    func performTransitionAnimation(presenting: Bool)
}
