//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

/// The Fullscreen Gallery Transition is a round-trip, and the Transition Presenter Delegate will be used
/// both when transitioning in, and when transitioning out.
///
/// The view returned by viewForFullscreenGalleryTransition will be scaled up to fill the screen when
/// transitioning in, and scaled into when transitioning out.
///
/// - Notes:
///   The view will be snapshot by the transition, so the view should be
///   fully loaded and ready to render before the transition is initiated.
public protocol FullscreenGalleryTransitionPresenterDelegate: class {
    func viewForFullscreenGalleryTransition() -> UIView
}
