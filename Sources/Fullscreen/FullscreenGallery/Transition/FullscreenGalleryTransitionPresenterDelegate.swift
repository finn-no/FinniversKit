//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

/// The Fullscreen Gallery Transition is a round-trip, and the Transition Presenter Delegate will be used
/// both when transitioning in, and when transitioning out.
public protocol FullscreenGalleryTransitionPresenterDelegate: class {
    /// - Notes:
    ///   An intermediate transition-view may be created from the 'image'-property of the returned view, so
    ///   the view should be fully loaded and ready to render before the transition is initiated.
    func imageViewForFullscreenGalleryTransitionIn() -> UIImageView?

    func fullscreenGalleryTransitionInCompleted()

    /// When transitioning out, the primary image-view of the Fullscreen Gallery will be animated to overlap
    /// the returned view.
    func viewForFullscreenGalleryTransitionOut() -> UIView?

    func fullscreenGalleryTransitionOutCompleted()
}
